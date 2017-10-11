/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 22/05/2017
* 
* Name: Fielo_TRIG_AccountAfter.cls
* 
* Class for after event of Account
*
*******************************************************************************/
public without sharing class Fielo_TRIG_AccountAfter {

    public static boolean ISRUNNING = false;

    // Rectype of Account
    public final static String PERSON_TERPEL_ID = RecType.getID('Account', 'Cliente Terpel');
    public final static String PERSON_LIFEMILES_ID = RecType.getID('Account', 'Cliente LifeMiles');
    public final static String TARJETA_PREINSCRITA_ID = RecType.getID('Account', 'Tarjeta Preinscrita');
    public final static String CUENTA_PERSONAL_B2C_ID = RecType.getID('Account', 'Cuenta personal B2C');
    // Rectypes of member
    public final static String CLIENTE_TERPEL_ID = RecType.getID('FieloPLT__Member__c', 'Cliente Terpel');
    public final static String CLIENTE_LIFEMILES_ID = RecType.getID('FieloPLT__Member__c', 'Cliente LifeMiles');
    public final static String CLIENTE_PREINSCRITA_ID = RecType.getID('FieloPLT__Member__c', 'Tarjeta Preinscrita');

    public final static Map<String,String> PERFIL_MAP = new Map<String,String>{
        'Fielo_ClienteTerpel'       => CLIENTE_TERPEL_ID,
        'Fielo_ClienteLifeMiles'    => CLIENTE_LIFEMILES_ID,
        'Fielo_TarjetaPreinscrita'  => CLIENTE_PREINSCRITA_ID
    };

    public static void createMember() {

        TriggerCheck.assert();              
        
        List<Account> lAccLst = new List<Account>();
        for(Account acc :(List<Account>) trigger.new) {

            if((acc.RecordTypeId == PERSON_TERPEL_ID || acc.RecordTypeId == PERSON_LIFEMILES_ID || acc.RecordTypeId == TARJETA_PREINSCRITA_ID) && 
                acc.F_Member__c == null && acc.F_CreateMember__c) {

                lAccLst.add(acc);
            }
        }

        if(lAccLst.size() == 0) return;

        List<FieloPLT__Member__c> lMemberLst = membersByAccounts(lAccLst, null);

        if(!lMemberLst.isEmpty()) insert lMemberLst;
        else return;
        // Insert reference Member/Account
        List<Account> lAccMbLst = new List<Account>();
        for(FieloPLT__Member__c mb :lMemberLst) {

            lAccMbLst.add(
                new Account(
                    id = mb.FieloPLT__Account__c,
                    F_Member__c = mb.id
                )
            );
        }

        ISRUNNING = true;

        if(!lAccMbLst.isEmpty()) update lAccMbLst;

        ISRUNNING = false;
    }


    public static void updateMember() {

        TriggerCheck.assert();

        if ( ISRUNNING ) return;

        List<Account> lAccLst = new List<Account>();
        for(Account acc :(List<Account>) trigger.new) {

            if((acc.RecordTypeId == PERSON_TERPEL_ID || acc.RecordTypeId == PERSON_LIFEMILES_ID || acc.RecordTypeId == TARJETA_PREINSCRITA_ID) && 
                acc.F_Member__c != Null && !TriggerCheck.isChangedFrom( acc, Account.F_Member__c, null)) {

                lAccLst.add(acc);
            }
        }
        
        if(lAccLst.size() == 0) return;

        Map<Id,Id> lAccMbIdsMap = new Map<Id,Id>();

        for(FieloPLT__Member__c mb :[SELECT Id, FieloPLT__Account__c 
                                     FROM FieloPLT__Member__c 
                                     WHERE FieloPLT__Account__c IN: lAccLst]) {

            lAccMbIdsMap.put(mb.FieloPLT__Account__c, mb.id);
        }
        
        List<FieloPLT__Member__c> lMemberLst = membersByAccounts(lAccLst, lAccMbIdsMap);

        if(!lMemberLst.isEmpty()) update lMemberLst;
    }

    public static List<FieloPLT__Member__c> membersByAccounts(List<Account> aAccLst, Map<Id,Id> aAccMbIdsMap) {

        List<FieloPLT__Member__c> lMemberLst = new List<FieloPLT__Member__c>();

        for(Account acc :aAccLst) {

            String lRecTypeId = PERFIL_MAP.get(acc.F_TipoMember__c);
            // If is a new account, or fields change
            String lMemberId = aAccMbIdsMap != null ?aAccMbIdsMap.get(acc.id): null;
            // Check changes
            if( lMemberId == null ||
                TriggerCheck.isChanged( acc, Account.F_TipoMember__c)       || 
                TriggerCheck.isChanged( acc, Account.F_NumeroLifeMiles__c) ||
                TriggerCheck.isChanged( acc, Account.FirstName) || 
                TriggerCheck.isChanged( acc, Account.MiddleName) ||
                TriggerCheck.isChanged( acc, Account.LastName) || 
                TriggerCheck.isChanged( acc, Account.Suffix) ||
                TriggerCheck.isChanged( acc, Account.PersonBirthdate) || 
                TriggerCheck.isChanged( acc, Account.PersonEmail) ||
                TriggerCheck.isChanged( acc, Account.PersonHomePhone) || 
                TriggerCheck.isChanged( acc, Account.PersonMobilePhone) || 
                TriggerCheck.isChanged( acc, Account.Ter_Genero__pc) || 
                TriggerCheck.isChanged( acc, Account.Ter_Tipo_documento__pc) ||                 
                TriggerCheck.isChanged( acc, Account.Ter_Pais_documento__pc) || 
                TriggerCheck.isChanged( acc, Account.Ter_Numero_de_identificacion__c) || 
                TriggerCheck.isChanged( acc, Account.BillingStreet) || 
                TriggerCheck.isChanged( acc, Account.BillingCity) ||
                TriggerCheck.isChanged( acc, Account.BillingState) || 
                TriggerCheck.isChanged( acc, Account.BillingPostalCode) || 
                TriggerCheck.isChanged( acc, Account.BillingCountry) || 
                TriggerCheck.isChanged( acc, Account.Ter_Tipo_de_vehiculo__c) ||                
                TriggerCheck.isChanged( acc, Account.Ter_OperadorCelular__c) || 
                TriggerCheck.isChanged( acc, Account.F_TipoTarjetaPreinscrita__c) || 
                TriggerCheck.isChanged( acc, Account.F_CodigoTarjetaPreinscrita__c) || 
                TriggerCheck.isChanged( acc, Account.F_ClubTerpelAgreementAccepted__c) ||           
                TriggerCheck.isChanged( acc, Account.F_ClubTerpelAgreementDate__c) || 
                TriggerCheck.isChanged( acc, Account.F_SessionId__c) || 
                TriggerCheck.isChanged( acc, Account.F_BalanceLifeMiles__c) ||
                TriggerCheck.isChanged( acc, Account.F_FechaActivacionTarjeta__pc) || 
                TriggerCheck.isChanged( acc, Account.F_FechaExpiracionTarjeta__pc) || 
                TriggerCheck.isChanged( acc, Account.F_EstadoTarjetaPreinscrita__c)) {
                

                lMemberLst.add( new FieloPLT__Member__c(
                    //OwnerId                         = UserInfo.getUserId(),
                    id                              = lMemberId,
                    RecordTypeId                    = lRecTypeId,
                    FieloPLT__Account__c            = acc.id,
                    FieloPLT__Contact__c            = acc.PersonContactId,
                    F_NumeroLifeMiles__c            = acc.F_NumeroLifeMiles__c,
                    F_PrimerNombre__c               = acc.FirstName,
                    F_SegundoNombre__c              = acc.MiddleName,
                    F_PrimerApellido__c             = acc.LastName,
                    F_SegundoApellido__c            = acc.Suffix,
                    F_BirthDate__c                  = acc.PersonBirthdate,
                    FieloPLT__Email__c              = acc.PersonEmail,
                    F_Phone__c                      = acc.PersonHomePhone,
                    F_MobilePhone__c                = acc.PersonMobilePhone,
                    F_Gender__c                     = acc.Ter_Genero__pc,
                    F_IdentificationType__c         = acc.Ter_Tipo_documento__pc,
                    F_IdentificationCountry__c      = acc.Ter_Pais_documento__pc,
                    F_IdentificationNumber__c       = acc.Ter_Numero_de_identificacion__c,
                    F_AddressStreet__c              = acc.BillingStreet,
                    F_AddressCity__c                = acc.BillingCity,
                    F_AddressState__c               = acc.BillingState,
                    F_AddressPostalCode__c          = acc.BillingPostalCode,
                    F_AddressCountry__c             = acc.BillingCountry,
                    F_TipoVehiculo__c               = acc.Ter_Tipo_de_vehiculo__c,
                    F_OperadorCelular__c            = acc.Ter_OperadorCelular__c,
                    F_TipoTarjetaPreinscrita__c     = acc.F_TipoTarjetaPreinscrita__c,
                    F_NumeroTarjetaPreinscrita__c   = acc.F_CodigoTarjetaPreinscrita__c,
                    F_AgreementAccepted__c          = acc.F_ClubTerpelAgreementAccepted__c,
                    F_AgreementDate__c              = acc.F_ClubTerpelAgreementDate__c,
                    F_SessionId__c                  = acc.F_SessionId__c,
                    F_BalanceLifeMiles__c           = acc.F_BalanceLifeMiles__c,
                    F_FechaActivacionTarjeta__c     = acc.F_FechaActivacionTarjeta__pc,
                    F_FechaExpiracionTarjeta__c     = acc.F_FechaExpiracionTarjeta__pc,
                    F_EstadoTarjetaPreinscrita__c   = acc.F_EstadoTarjetaPreinscrita__c
                ));
            }
        }
        return lMemberLst;
    }
}