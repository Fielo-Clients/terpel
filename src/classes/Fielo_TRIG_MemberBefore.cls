/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 22/05/2017
* 
* Name: Fielo_TRIG_MemberBefore.cls
* 
* Class for before event of Fielo Member object
*
*******************************************************************************/
public without sharing class Fielo_TRIG_MemberBefore {
    // Rectypes of member
    public final static String CLIENTE_TERPEL_ID = RecType.getID('FieloPLT__Member__c', 'Cliente Terpel');
    public final static String CLIENTE_LIFEMILES_ID = RecType.getID('FieloPLT__Member__c', 'Cliente LifeMiles');
    // Org settings
    private static Organization orgSettings {get{if(orgSettings == null){orgSettings = [SELECT DefaultLocaleSidKey, LanguageLocaleKey FROM Organization];}return orgSettings;}}
    // Rectypes of User
    private static Id profileId {get{
                                    if(profileId == null){                                                                                
                                        profileId = [SELECT Id FROM Profile WHERE Name = 'Fielo Member Site'].get(0).Id;                                                                                                                                                            
                                    }
                                    return profileId;
                                }} 

    public static boolean ISRUNNING_MERGE_TARJETA = false;  

    public static void updateBalanceLifeMilesToPoints() {
        
        TriggerCheck.assert();

        List<FieloPLT__Member__c> lMemberLst = (List<FieloPLT__Member__c>) trigger.new;

        for( FieloPLT__Member__c lMember : lMemberLst ){ 
            if (TriggerCheck.isChanged( lMember, FieloPLT__Member__c.F_BalanceLifeMiles__c)){

                lMember.FieloPLT__Points__c = lMember.F_BalanceLifeMiles__c;
            } else if (TriggerCheck.isChanged( lMember, FieloPLT__Member__c.FieloPLT__Points__c)){

                lMember.F_BalanceLifeMiles__c = lMember.FieloPLT__Points__c;
            } 
        }
    }

    public static void createUser() {

        TriggerCheck.assert();

        Map<String,User> lUserMap = new Map<String,User>();
        List<FieloPLT__Member__c> LMemberlst = new List<FieloPLT__Member__c>();
        for(FieloPLT__Member__c mb :(List<FieloPLT__Member__c>) trigger.new) {
            
            if((mb.RecordTypeId == CLIENTE_TERPEL_ID || 
                    mb.RecordTypeId == CLIENTE_LIFEMILES_ID) &&
                    mb.FieloPLT__Contact__c != null &&
                    mb.FieloPLT__User__c == null ) {

                User lUser = getUser(mb, mb.FieloPLT__Contact__c);
                lUserMap.put(mb.F_NumeroLifeMiles__c, lUser);
                LMemberlst.add(mb); 
            }
        }

        if(lUserMap.size() == 0) return;

        insert lUserMap.values();

        for(FieloPLT__Member__c mb :LMemberlst) {
            
            User lUser = lUserMap.get(mb.F_NumeroLifeMiles__c);
            if(lUser != null) {

                mb.FieloPLT__User__c = lUser.id;
                if(TriggerCheck.isChanged(mb, FieloPLT__Member__c.F_SessionId__c) && mb.F_SessionId__c != null) {
                    system.setPassword(lUser.id, mb.F_SessionId__c);
                }               
            }           
        }
    }

    public static void updateUser() {

        TriggerCheck.assert();

        Boolean lCreateUser = false;
        Set<Id> lIdMemberSet = new Set<Id>();
        Map<Id,String> lUserSessionMap = new Map<Id,String>();
        for(FieloPLT__Member__c mb :(List<FieloPLT__Member__c>) trigger.new) {
            
            if(mb.RecordTypeId == CLIENTE_TERPEL_ID || mb.RecordTypeId == CLIENTE_LIFEMILES_ID) {

               
                if(mb.FieloPLT__User__c != null) {

                    // Atualiza senha do usuario caso o id da sessão tenha sido alterado 
                    if(TriggerCheck.isChanged( mb, FieloPLT__Member__c.F_SessionId__c)) {
                                                
                        lUserSessionMap.put(mb.FieloPLT__User__c, mb.F_SessionId__c);                        
                    }   

                    // Atualiza dados do usuario vinculado ao member
                    if( TriggerCheck.isChanged( mb, FieloPLT__Member__c.FieloPLT__Email__c) ||
                        TriggerCheck.isChanged( mb, FieloPLT__Member__c.F_NumeroLifeMiles__c)) {

                        lIdMemberSet.add(mb.id);
                    }                   
                }
                else lCreateUser = true;                
            }
        }

        if(!lUserSessionMap.values().isEmpty()) {

            for(User us :[SELECT id 
                            FROM User 
                            WHERE id IN :lUserSessionMap.keySet()
                            AND IsActive = true]) {

                try{
                    system.setPassword(us.id, lUserSessionMap.get(us.id));
                }
                catch(Exception e) {
                    system.debug('Password User: ' + e);
                }
            }
        }

        // Update User on future method, the salesforce does not allow 
        // the update of custom objects with the system objects
        if(!lIdMemberSet.isEmpty()) updateUserFuture(lIdMemberSet);

        // Creates User for Member who have updated without User
        if(lCreateUser) createUser();
    }

    // Used part of the code UserCreationFielo
    private static User getUser(FieloPLT__Member__c m, Id contactId){  

        if(m.F_PrimerApellido__c == null) {
            m.F_PrimerApellido__c = 'Fielo';
        }              
        String userName = m.F_NumeroLifeMiles__c + '@clubterpel.com';            
        String email = m.FieloPLT__Email__c;      
        String communityNickname = m.F_PrimerApellido__c + String.valueOf(contactId).substring(12,15);   
        String alias = (m.F_PrimerApellido__c.length()>4) ? m.F_PrimerApellido__c.substring(0,4) : m.F_PrimerApellido__c;                    
        String language = orgSettings.LanguageLocaleKey;
        String locale = orgSettings.LanguageLocaleKey;
        String timeZone = UserInfo.getTimeZone().getId();
        User u = new User(
                Username = userName, Email = email, LastName = m.F_PrimerApellido__c, Alias = alias, emailencodingkey='UTF-8', 
                ProfileId = profileId, contactId = contactId, LocaleSidKey = locale, TimeZoneSidKey = timeZone, LanguageLocaleKey = language,
                CommunityNickname = communityNickname);
                            
        return u;
    }

    @Future
    private static void updateUserFuture( Set<Id> aIdMembersSet ) {

        List<FieloPLT__Member__c> lMemberLst = [
            SELECT id, FieloPLT__User__c, 
                F_NumeroLifeMiles__c, FieloPLT__Email__c
            FROM FieloPLT__Member__c
            WHERE id IN :aIdMembersSet];

        if(lMemberLst.size() == 0) return;

        list<User> lUserLst = new list<User>();
        for(FieloPLT__Member__c mb :lMemberLst) {

            lUserLst.add( new User(
                            id = mb.FieloPLT__User__c,
                            Username = mb.F_NumeroLifeMiles__c + '@clubterpel.com',
                            Email = mb.FieloPLT__Email__c
                        )                       
            );
        }   
        
        update lUserLst;
    }

    public static void mergeTarjetaPreinscrita() {

        TriggerCheck.assert();

        if ( ISRUNNING_MERGE_TARJETA ) return;               

        Set<String> lTarjetaSet = new Set<String>();
        List<FieloPLT__Member__c> lMembersLst = new List<FieloPLT__Member__c>();
        for(FieloPLT__Member__c mb :(List<FieloPLT__Member__c>) trigger.new) {
            
            if(mb.RecordTypeId == CLIENTE_TERPEL_ID && mb.F_AsignarTarjetaPreinscrita__c != NULL) {

                if(TriggerCheck.isChanged( mb, FieloPLT__Member__c.F_AsignarTarjetaPreinscrita__c )) {

                    lMembersLst.add(mb);
                    lTarjetaSet.add(mb.F_AsignarTarjetaPreinscrita__c);
                }                
            }
        }

        if(lTarjetaSet.isEmpty()) return;

        ISRUNNING_MERGE_TARJETA = true;   

        Map<String,FieloPLT__Member__c> lTajetasMap = new Map<String,FieloPLT__Member__c>();
        for(FieloPLT__Member__c mb :[SELECT FieloPLT__Points__c, F_NumeroTarjetaPreinscrita__c 
                                    FROM FieloPLT__Member__c 
                                    WHERE F_NumeroTarjetaPreinscrita__c IN :lTarjetaSet
                                    AND RecordType.DeveloperName = 'Fielo_TarjetaPreinscrita'
                                    //AND F_TipoTarjetaPreinscrita__c = 'Física'
                                    AND F_EstadoTarjetaPreinscrita__c IN ('Activa', 'Asignada')]) {

            lTajetasMap.put(mb.F_NumeroTarjetaPreinscrita__c, mb);
        }
        
        List<Fielo_Autorizacion_LifeMiles__c> lAutorizacionLifeMilesLst = new List<Fielo_Autorizacion_LifeMiles__c>();
        for(FieloPLT__Member__c mb :lMembersLst) {

            FieloPLT__Member__c lTarjetaAux = lTajetasMap.get(mb.F_AsignarTarjetaPreinscrita__c);
            if(lTarjetaAux == null) {
                mb.addError(Label.Fielo_TarjetaPreinscritaNoDisponible);
                continue;
            }

            lAutorizacionLifeMilesLst.add( new Fielo_Autorizacion_LifeMiles__c(
                F_MotivoRechazo__c = lTarjetaAux.FieloPLT__Points__c > 0 ?'': Label.Fielo_AutorizacionSinPuntos,
                F_Estado__c = lTarjetaAux.FieloPLT__Points__c > 0 ?'Pendiente': 'Cancelado', 
                F_MillasBase__c = lTarjetaAux.FieloPLT__Points__c,
                F_NumeroLifeMiles__c = mb.F_NumeroLifeMiles__c,
                F_TarjetaPreinscrita__c  = lTarjetaAux.id ,
                F_TipoTransaccion__c = 'Crédito (C)',
                F_MillasPromocionales__c = 0,
                F_Member__c = mb.id,
                F_IdTransaccion__c = Ter_Utilidades_cls.obtenerTransaccionIdLifeMiles()        
            ));
        }

        // Verificar se chama o método "Acumulación Millas LifeMiles" antes ou depois de 
        // salvar a lista de autorização
        if(lAutorizacionLifeMilesLst.isEmpty()) return;

        List<FieloPLT__Member__c> lTarjetaToUpdateLst = new List<FieloPLT__Member__c>();
        Map<id,FieloPLT__Member__c> lMembersMap = (Map<id,FieloPLT__Member__c>) trigger.newMap;
        for(Fielo_Autorizacion_LifeMiles__c alf :lAutorizacionLifeMilesLst) {

            FieloPLT__Member__c lMemberAux = lMembersMap.get(alf.F_Member__c);            
            FieloPLT__Member__c lTarjetaAux = lTajetasMap.get(lMemberAux.F_AsignarTarjetaPreinscrita__c);
            lMemberAux.F_TarjetaPreinscritaAsignada__c = lTarjetaAux.id;
            lTarjetaAux.F_EstadoTarjetaPreinscrita__c = 'Utilizada';
            lTarjetaToUpdateLst.add(lTarjetaAux);
        }

        if(!lTarjetaToUpdateLst.isEmpty()) update lTarjetaToUpdateLst;

        insert lAutorizacionLifeMilesLst;
    }
}