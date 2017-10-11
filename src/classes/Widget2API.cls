global with sharing class Widget2API implements FieloCMS.ViewInterface{

    public FieloPLT__Member__c fMember { get; set;} 

    public static String fNumTarjetaAsignar{ get; set;} 
    public String fPointsTarjeta { get; set;} 

    public static String fMsgError { get; set;} 
    public static String fMsgInfo { get; set;} 

    public Widget2API() {
        fMember = Fielo_UTIL_Member.loggedMember;

        if(fMember == null) {

            return;
        }
        
        if(String.isNotBlank(fMember.F_AsignarTarjetaPreinscrita__c)) {
            fNumTarjetaAsignar = fMember.F_AsignarTarjetaPreinscrita__c;
        }
        
    }

    global ApexPages.Component getComponent(FieloCMS__Component__c c){     
                 
       Component.Widget2 tarjeta = new Component.Widget2(config=c);

       return tarjeta;        
   }

   public void searchTarjeta() {
        fMsgError = fMsgInfo = null;
        fPointsTarjeta = null;

        if(String.isNotEmpty(fNumTarjetaAsignar)) {

            List<FieloPLT__Member__c> lTarjetaLst = [
                SELECT FieloPLT__Points__c, F_EstadoTarjetaPreinscrita__c 
                FROM FieloPLT__Member__c 
                WHERE F_NumeroTarjetaPreinscrita__c = :fNumTarjetaAsignar
                AND RecordType.DeveloperName = 'Fielo_TarjetaPreinscrita'];
                //AND F_TipoTarjetaPreinscrita__c = 'Física'];

            if(lTarjetaLst.size() > 0) {
                
                if(lTarjetaLst[0].F_EstadoTarjetaPreinscrita__c == 'Expirada') {
                    fMsgError = Label.Fielo_TarjetaPreinscritaExpirada;
                }
                else if(lTarjetaLst[0].F_EstadoTarjetaPreinscrita__c == 'Utilizada') {
                    fMsgError = Label.Fielo_TarjetaPreinscritaUtilizada;
                }
                else if(lTarjetaLst[0].F_EstadoTarjetaPreinscrita__c != 'Activa' && lTarjetaLst[0].F_EstadoTarjetaPreinscrita__c != 'Asignada') {
                    fMsgError = Label.Fielo_TarjetaPreinscritaNoHabilitada;
                }
                else {
                    fPointsTarjeta = lTarjetaLst[0].FieloPLT__Points__c.format();
                    fMsgInfo = 'Millas acumuladas en la tarjeta: ' + fPointsTarjeta;                 
                }               
            }
            else {
                fMsgError = Label.Fielo_TarjetaPreinscritaInexistente;
            }
        }
        else {
            fMsgError = 'El número ingresado no es válido';
        }
    }

    public void save() {
        fMsgError = fMsgInfo = null;

        if(String.isNotEmpty(fNumTarjetaAsignar)) {
            fMember.F_AsignarTarjetaPreinscrita__c = fNumTarjetaAsignar;
        }
        
        try{
            update fMember;
            fMsgInfo = 'Los datos han sido actualizados';
        }
        catch(DmlException e) {

            fMsgError = 'Error: ' + e.getDmlMessage(0); 
        }
    }
}