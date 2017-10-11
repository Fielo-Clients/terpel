/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de manejar la construcion de xml del webservice de redencion
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		16/06/2017		Cristian Mosquera (CM)		Implementacion inicial la clase.
**/
public class Ter_BuilderRequestRedention_cls {

    /** Instancia de utileria de xml.**/
    private Ter_BuilderXMLUtil_cls builderXMLUtil_cls = new Ter_BuilderXMLUtil_cls();

     /** La utileria de cifrado. **/
    private Ter_UtilEncriptacion_cls ter_utilEncriptacion = new Ter_UtilEncriptacion_cls();

    /**
     * Metodo encragado de construir un xml apartir de un DTO.
     * @param request el dto con los datos que desea convertir a xml.
     * @return el xml generado.
     */
    public String built(Ter_RequestRedentionDTO_cls request) {

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

        Ter_BuilderXMLUtil_cls.XmlElement elementPostingRequest = Ter_BuilderXMLUtil_cls.createElement('PostingRequest', null, null);
        elementBody.addChild(elementPostingRequest);
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('transaction_id', request.getTransactionId(), null));
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('member_id', request.getMemberId(), null));
        
        if(request.getSession() != null){
        	elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('session', request.getSession(), null));
        } 
        
        if(request.getPin() != null){
        	//String cryptPass = Ter_UtilEncriptacion_cls.calcularSHA256(request.getPin() + request.getMemberId());
        	String cryptPass = ter_utilEncriptacion.encriptarAES256LifeMiles_B64(request.getPin());
            elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('password', cryptPass, null));
        }
        
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('posting_amount', request.getPostingAmount(), null));
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('posting_equivalent', request.getPostingEquivalent(), null));
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('partner_code', customSettingsLifeMiles.TER_SENDER_CODE__c, null));
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('transaction_type', request.getTransactionType(), null));
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('transaction_date', request.getTransactionDate(), null));
        elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('transaction_desc', request.getTransactionDesc(), null));
        
        /*if (request.getSession() != null) {
            String cryptPass = Ter_UtilEncriptacion_cls.calcularSHA256(request.getPin() + request.getMemberId());
            elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('password', cryptPass, null));
        } */

		if(request.getTransactionIdSource() != null){
        	elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('transaction_id_source', request.getTransactionIdSource(), null));
		}
		
        if(request.getDiscountAmount() != null){
        	elementPostingRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('discount_amount', request.getDiscountAmount(), null));
        }

        for (Ter_RequestRedentionDTO_cls.AwardDTO awardDTO : request.getAwards()) {

            Ter_BuilderXMLUtil_cls.XmlElement elementAwardRequest = Ter_BuilderXMLUtil_cls.createElement('selected_award', null, null);
            elementAwardRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('award_code', awardDTO.getAwardCode(), null));
            elementAwardRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('award_name', awardDTO.getAwardName(), null));
            elementAwardRequest.addChild(Ter_BuilderXMLUtil_cls.createElement('award_detai', awardDTO.getAwardDetail(), null));

            elementPostingRequest.addChild(elementAwardRequest);
        }
        return  builderXMLUtil_cls.builtXml(document);

    }
}