public with sharing class Ter_BuilderRequestGuest_cls {
	
	/** Instancia de utileria de xml.**/
    private Ter_BuilderXMLUtil_cls builderXMLUtil_cls = new Ter_BuilderXMLUtil_cls();

     /** La utileria de cifrado. **/
    private Ter_UtilEncriptacion_cls ter_utilEncriptacion = new Ter_UtilEncriptacion_cls();

    /**
     * Metodo encragado de construir un xml apartir de un DTO.
     * @param request el dto con los datos que desea convertir a xml.
     * @return el xml generado.
     */
    public String builtSecurityTokenValidation(Ter_RequestGuestDTO_cls request) {
    	Ter_BuilderXMLUtil_cls.XmlDocument document = new Ter_BuilderXMLUtil_cls.XmlDocument();
        document.setName('Envelope');
        List<Ter_BuilderXMLUtil_cls.XmlElement> elements = new List<Ter_BuilderXMLUtil_cls.XmlElement>();
        Ter_BuilderXMLUtil_cls.XmlElement elementHeader = Ter_BuilderXMLUtil_cls.createElement('Header', null, null);
        Ter_BuilderXMLUtil_cls.XmlElement elementBody = Ter_BuilderXMLUtil_cls.createElement('Body', null, null);
        document.addChild(elementHeader);
        document.addChild(elementBody);
        Fielo_ParametrosLifeMiles__c customSettingsLifeMiles = Fielo_ParametrosLifeMiles__c.getInstance('Ter_Custom_Settings_WS');
        elementHeader.addChild(Ter_BuilderXMLUtil_cls.createElement('username', ter_utilEncriptacion.encriptarAES256LifeMiles_B64(customSettingsLifeMiles.TER_USERNAME__c), null));
        elementHeader.addChild(Ter_BuilderXMLUtil_cls.createElement('password', ter_utilEncriptacion.encriptarAES256LifeMiles_B64(customSettingsLifeMiles.TER_PASSWORD__c), null));

        Ter_BuilderXMLUtil_cls.XmlElement elementPostingRequest = Ter_BuilderXMLUtil_cls.createElement('SecurityTokenValidationRequest', null, null);
        elementBody.addChild(elementPostingRequest);
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('token', request.strToken, null));
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('member_id', request.strMemberId, null));
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('partner_code', customSettingsLifeMiles.TER_SENDER_CODE__c, null));

    
        return  builderXMLUtil_cls.builtXml(document);
    }
    
    /**
     * Metodo encragado de construir un xml apartir de un DTO.
     * @param request el dto con los datos que desea convertir a xml.
     * @return el xml generado.
     */
    public String builtValidateMember(Ter_RequestGuestDTO_cls request) {
    	Ter_BuilderXMLUtil_cls.XmlDocument document = new Ter_BuilderXMLUtil_cls.XmlDocument();
        document.setName('Envelope');
        List<Ter_BuilderXMLUtil_cls.XmlElement> elements = new List<Ter_BuilderXMLUtil_cls.XmlElement>();
        Ter_BuilderXMLUtil_cls.XmlElement elementHeader = Ter_BuilderXMLUtil_cls.createElement('Header', null, null);
        Ter_BuilderXMLUtil_cls.XmlElement elementBody = Ter_BuilderXMLUtil_cls.createElement('Body', null, null);
        document.addChild(elementHeader);
        document.addChild(elementBody);
        Fielo_ParametrosLifeMiles__c customSettingsLifeMiles = Fielo_ParametrosLifeMiles__c.getInstance('Ter_Custom_Settings_WS');
        elementHeader.addChild(Ter_BuilderXMLUtil_cls.createElement('username', ter_utilEncriptacion.encriptarAES256LifeMiles_B64(customSettingsLifeMiles.TER_USERNAME__c), null));
        elementHeader.addChild(Ter_BuilderXMLUtil_cls.createElement('password', ter_utilEncriptacion.encriptarAES256LifeMiles_B64(customSettingsLifeMiles.TER_PASSWORD__c), null));

        Ter_BuilderXMLUtil_cls.XmlElement elementPostingRequest = Ter_BuilderXMLUtil_cls.createElement('MemberValidationRequest', null, null);
        elementBody.addChild(elementPostingRequest);
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('session', request.strSession, null));
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('member_id', request.strMemberId, null));
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('partner_code', customSettingsLifeMiles.TER_SENDER_CODE__c, null));

    
        return  builderXMLUtil_cls.builtXml(document);
    }
    
    public class Ter_RequestGuestDTO_cls{
    	public String strToken {get; set;}
    	public String strMemberId {get; set;}
    	public String strSession {get; set;}
    }
    
}