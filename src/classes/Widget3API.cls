global with sharing class Widget3API implements FieloCMS.ViewInterface{

    public FieloPLT__Member__c fMember { get; set; }
    public static String fNombre { get; set; }
    public static String fEmail { get; set; }
    public static String fTelefono { get; set; }
    public static String fAsunto { get; set; }
    public static String fDescripcion { get; set; }
    public static String fMsgError { get; set; }
    public static String fMsgInfo { get; set; }

    global ApexPages.Component getComponent(FieloCMS__Component__c c){                
        Component.Widget3 contactanos = new Component.Widget3(config=c);
        return contactanos;        
    }

  public Widget3API() {

        fMember = Fielo_UTIL_Member.getAllFieldsLoggedMember();         
    }

    public PageReference enviar() {
        Id lIdMember;
        fMsgError = fMsgInfo = null;

        if (fMember != null){
            fEmail = fMember.FieloPLT__Email__c;    
            fTelefono = fMember.F_Phone__c;
            fNombre = fMember.Name;     
            lIdMember = fMember.id;
        }

        if ( (fMember == null && (String.isBlank(fTelefono) || String.isBlank(fNombre) || String.isBlank(fEmail))) 
                || String.isBlank(fAsunto) || String.isBlank(fDescripcion) ){
            fMsgError = Label.Fielo_CamposRequeridos;
            return null;
        }

        if (!validaEMail(fEmail)) {
            fMsgError = Label.Fielo_InvalidEmail;
            return null;
        }

        Fielo_Contactenos__c lContactenos = new Fielo_Contactenos__c();
        lContactenos.F_Email__c = fEmail;
        lContactenos.F_Asunto__c = fAsunto;
        lContactenos.F_Nombre__c = fNombre;
        lContactenos.F_Member__c = lIdMember;
        lContactenos.F_Descripcion__c = fDescripcion;
        lContactenos.F_NumeroTelefono__c = fTelefono;

        try{
          insert lContactenos;
          fMsgInfo = Label.Fielo_ContactenosEnviado;
          clearFields();
      }
      catch(DmlException e) {

          fMsgError = 'Error: ' + e.getDmlMessage(0); 
      }

        return null;
    }

    private boolean validaEMail( string aEmail ) {
        if ( String.isBlank(aEmail) ) return false;
        Pattern MyPattern = Pattern.compile( '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$' );
        Matcher MyMatcher = MyPattern.matcher( aEmail );
        return MyMatcher.matches();
  }

    private void clearFields() {
        fNombre = '';
        fEmail = '';
        fTelefono = '';
        fAsunto = '';
        fDescripcion = '';
    }
}