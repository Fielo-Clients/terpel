/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargado orquestar los llamados al webservice de redencion.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		20/06/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
public class Ter_LifeMilesConversionWsConsumer_cls {
	
	/** Instancia del servicio.**/
    private Ter_LifeMilesComPartnersService_cls.EndpointHttpsSoap11 service;

    private Fielo_ParametrosLifeMiles__c customSettingsLifeMiles;
    
	
	public Ter_LifeMilesConversionWsConsumer_cls(){
		this.service = new Ter_LifeMilesComPartnersService_cls.EndpointHttpsSoap11();
		this.customSettingsLifeMiles = Fielo_ParametrosLifeMiles__c.getInstance('Ter_Custom_Settings_WS');
	}
	

    /**
     * Metodo encargado de invocar el servicio de redencion.
     * @param request la peticion.
     * @return la respuesta de la redencion.
     * @throws Ter_ValidationWsException en caso de un error de validacion d datos.
     */
    public Ter_ResponseRedentionDTO_cls invokePostMilesStr( Ter_RequestRedentionDTO_cls request) {
    	Ter_BuilderRequestRedention_cls  builderRequestRedention;
        validateInputData(request);
        
        builderRequestRedention = new Ter_BuilderRequestRedention_cls();
        String xml = builderRequestRedention.built(request);
        
        service.endpoint_x = this.customSettingsLifeMiles.TER_ENDPOINT_REDENCION__c;
        service.timeout_x = Integer.ValueOf(this.customSettingsLifeMiles.TER_TIMEOUT__c);
        system.debug('=======>>>> EndPoint: ' + service.endpoint_x);
        system.debug('=======>>>> xmlRequest: ' + xml);
        
        String xmlResponse = service.postMilesStr(xml);
        system.debug('=======>>>> xmlResponse: ' + xmlResponse);
        Ter_ResponseRedentionDTO_cls objResponse = (Ter_ResponseRedentionDTO_cls)
                Ter_BuilderXMLUtil_cls.xmlToSObject(xmlResponse, Ter_ResponseRedentionDTO_cls.class);
                
        /*if (!Label.TER_SUCCESS_CODE_LIFE_CONVERSION_MILES.equals (objResponse.getBody().getPostingResponse().getResponse_code())) {
            throw new Ter_ValidationWsException ('Ocurrio un error con codigo : ' + objResponse.getBody().getPostingResponse().getResponse_code());
        }*/

        return objResponse; 
    }
    
    /* 
	* Nombre: procesaRedencion
    * Descripcion: Metodo que contiene la logica necesaria para constuir la transaccion de redencion para ser enviada a LifeMiles
    * Fecha Creación: 07/09/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            07-Sep-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public Ter_ResponseRedentionDTO_cls invokePostMilesStr(Fielo_Autorizacion_LifeMiles__c objAutorizacionLifeMiles, String strPIN, String strSessionId) {
		Ter_RequestRedentionDTO_cls objRequest;
     	Ter_ResponseRedentionDTO_cls response;
     	Ter_ResponseRedentionDTO_cls objResponse;
     	list<Fielo_Autorizacion_LifeMiles__c> lstAutorizacionLifeMilesPadre;
     	
     	objRequest = new Ter_RequestRedentionDTO_cls();
     	
     	if(objAutorizacionLifeMiles.F_IdTransaccion__c == null){
			objAutorizacionLifeMiles.F_IdTransaccion__c = Ter_Utilidades_cls.obtenerTransaccionIdLifeMiles();
		}
		
		if(objAutorizacionLifeMiles.F_MillasBase__c == null){
			objAutorizacionLifeMiles.F_MillasBase__c = 0;
		}
		
		if(objAutorizacionLifeMiles.F_MillasPromocionales__c == null){
			objAutorizacionLifeMiles.F_MillasPromocionales__c = 0;
		}
		
		if(objAutorizacionLifeMiles.F_TipoTransaccion__c.equals('Débito (D)')){
			objRequest.setTransactionType('D'); //Va a ser usado en fase 2 para la Redención
		} else if(objAutorizacionLifeMiles.F_TipoTransaccion__c.equals('Reversión (R)')){
			objRequest.setTransactionType('R'); 
		} else{
			throw new Ter_AcumulacionException('No se reconoce el tipo de transacción.');
		}
		
		
		if(objAutorizacionLifeMiles.F_AutorizacionLMPadre__c != null){
			lstAutorizacionLifeMilesPadre = [SELECT F_IdTransaccion__c FROM Fielo_Autorizacion_LifeMiles__c WHERE id = :objAutorizacionLifeMiles.F_AutorizacionLMPadre__c];
			objRequest.setTransactionIdSource(lstAutorizacionLifeMilesPadre.get(0).F_IdTransaccion__c);//Identificador de transaccion a reversar
		}
		
		if(objAutorizacionLifeMiles.F_MontoTransaccion__c != null){
			objRequest.setPostingEquivalent(String.ValueOf(Integer.ValueOf(objAutorizacionLifeMiles.F_MontoTransaccion__c)));
		}
		
		if(!String.isBlank(strSessionId)){
			objRequest.setSession(strSessionId);/////aplica para portal 
		}
		
		if(!String.isBlank(strPIN)){
			objRequest.setPin(strPIN);
		}
		
		objRequest.setTransactionId(objAutorizacionLifeMiles.F_IdTransaccion__c);
		objRequest.setMemberId(objAutorizacionLifeMiles.F_NumeroLifeMiles__c);//Numero Lifemiles
		objRequest.setPostingAmount(String.ValueOf(Integer.ValueOf(objAutorizacionLifeMiles.F_MillasBase__c)));
		objRequest.setTransactionDesc('Redencion ' + objAutorizacionLifeMiles.F_IdTransaccion__c + ' para el cliente ' + objAutorizacionLifeMiles.F_NumeroLifeMiles__c);
		objRequest.setTransactionDate(Ter_Utilidades_cls.obtenerFechaActualFormateadaStr('yyyyMMdd'));
     	
     	
     	//objRequest.getTransactionId();
     	//objRequest.getMemberId();
     	//objRequest.getPostingAmount();
     	//objRequest.getPostingEquivalent();
     	//objRequest.getTransactionType();
     	//objRequest.getTransactionDate();
     	//objRequest.getTransactionDesc();
     	//objRequest.getPin();
     	//objRequest.getSession();/////aplica para portal
     	
     	
     	objResponse = invokePostMilesStr(objRequest);
     	
     	return objResponse;
	}

    /**
     * Metodo encrgado de validar la data de entrada
     * @param request la peticion que desea validar.
     * @throws Ter_ValidationWsException en caso de un error de validacion.
     */
    public void validateInputData(Ter_RequestRedentionDTO_cls request) {
        /*if (String.isBlank(request.getUsername())) {
            throw new Ter_ValidationWsException(Label.TER_USERNAME_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getUsername(),
                Integer.valueOf(Label.TER_USERNAME_MAX_CHARACTERS))) {
            throw new Ter_ValidationWsException(Label.TER_USERNAME_EXCEDED_MAX_CHARS);
        }*/

       /* if (String.isBlank(request.getPassword())) {
            throw new Ter_ValidationWsException(Label.TER_PASSWORD_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getPassword(),
                Integer.valueOf(Label.TER_PASSWORD_MAX_CHARACTERS))) {
            throw new Ter_ValidationWsException(Label.TER_PASSWORD_EXCEDED_MAX_CHARS);
        }*/


        /*if (Ter_FormatUtils.excededMaxCharacters(request.getPassword2(),
                Integer.valueOf(Label.TER_PASSWORD2_MAX_CHARACTERS))) {
            throw new Ter_ValidationWsException(Label.TER_PASSWORD_EXCEDED_MAX_CHARS);
        }*/

        if (String.isBlank(request.getTransactionId())) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_ID_IS_REQUIRED);
        }
        
       /* if (Ter_FormatUtils.excededMaxCharacters(request.getTransactionId(),
                Integer.valueOf(Label.TER_TRANSACTION_LIFE_CONVS_ID_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_ID_EXCEDED_MAX_CHARS);
        }*/

        if (String.isBlank(request.getMemberId())) {
            throw new Ter_ValidationWsException(Label.TER_MEMBER_ID_IS_REQUIRED);
        }

        /*if (Ter_FormatUtils.excededMaxCharacters(request.getMemberId(),
                Integer.valueOf(Label.TER_MEMBER_ID_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_MEMBER_ID_EXCEDED_MAX_CHARS);
        }*/

        /*if (String.isBlank(request.getSession())) {
            throw new Ter_ValidationWsException(Label.TER_SESSION_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getSession(),
                Integer.valueOf(Label.TER_SESSION_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_SESSION_EXCEDED_MAX_CHARS);
        }*/


        /*if (Ter_FormatUtils.excededMaxCharacters(request.getTransactionIdSource(),
                Integer.valueOf(Label.TER_TRANSACTION_SOURCE_LIFE_CONVS_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_ID_SOURCE_EXCEDED_MAX_CHARS);
        }*/

        if (String.isBlank(request.getPostingAmount())) {
            throw new Ter_ValidationWsException(Label.TER_POST_AMOUNT_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getPostingAmount(),
                Integer.valueOf(Label.TER_POST_AMOUNT_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_POST_AMOUNT_EXCEDED_MAX_CHARS);
        }

        /*if (Ter_FormatUtils.excededMaxCharacters(request.getDiscountAmount(),
                Integer.valueOf(Label.TER_DISCOUNT_AMOUNT_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_DISCOUNT_AMOUNT_EXCEDED_MAX_CHARS);
        }*/

        if (String.isBlank(request.getPostingEquivalent())) {
            throw new Ter_ValidationWsException(Label.TER_POST_EQUIV_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getPostingEquivalent(),
                Integer.valueOf(Label.TER_POST_EQUIV_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_POST_EQUIV_EXCEDED_MAX_CHARS);
        }

        /*if (String.isBlank(request.getPartnerCode())) {
            throw new Ter_ValidationWsException(Label.TER_PARTNER_CODE_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getPartnerCode(),
                Integer.valueOf(Label.TER_PARTNER_CODE_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_PARTNER_CODE_EXCEDED_MAX_CHARS);
        }*/

        if (String.isBlank(request.getTransactionType())) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_TYPE_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getTransactionType(),
                Integer.valueOf(Label.TER_TRANSACTION_TYPE_LIFE_CONVS_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_TYPE_EXCEDED_MAX_CHARS);
        }

        if (String.isBlank(request.getTransactionDate())) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_DATE_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getTransactionDate(),
                Integer.valueOf(Label.TER_TRANSACTION_DATE_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_DATE_EXCEDED_MAX_CHARS);
        }

        if (String.isBlank(request.getTransactionDesc())) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_DESC_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getTransactionDesc(),
                Integer.valueOf(Label.TER_TRANSACTION_DESC_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_DESC_EXCEDED_MAX_CHARS);
        }
    }
    
    public Ter_SecurityTokenValidationResponse invokeValidateSecurityTokenStr(String strToken, String strMemberId) {
        Ter_SecurityTokenValidationResponse objResponse;
        String xml;
        //xml = '<Envelope> <Header> <username>Bsf4g+Y/JxxDu1LAhncB0Q==</username> <password>njSzDmyvbifX1sHtUjxj2w==</password> </Header> <Body> <SecurityTokenValidationRequest> <token>0000034745201707241615340</token> <member_id>13428703035</member_id> <partner_code>TEPCO</partner_code> </SecurityTokenValidationRequest> </Body> </Envelope>';
        Ter_BuilderRequestGuest_cls.Ter_RequestGuestDTO_cls objRequestGuestDTO = new Ter_BuilderRequestGuest_cls.Ter_RequestGuestDTO_cls();
        
        objRequestGuestDTO.strToken = strToken;
        objRequestGuestDTO.strMemberId = strMemberId;
        
        Ter_BuilderRequestGuest_cls objBuilderRequestGuest  = new Ter_BuilderRequestGuest_cls();
        xml = objBuilderRequestGuest.builtSecurityTokenValidation(objRequestGuestDTO);
        system.debug('=======>>>> xml: ' + xml);
        service.endpoint_x = this.customSettingsLifeMiles.TER_ENDPOINT_VST__c;
        service.timeout_x = Integer.ValueOf(this.customSettingsLifeMiles.TER_TIMEOUT__c); 
        system.debug('=======>>>> EndPoint: ' + service.endpoint_x); 
        system.debug('=======>>>> xmlRequest: ' + xml);
        
        String xmlResponse = service.validateSecurityTokenStr(xml);
        system.debug('=======>>>> xmlResponse: ' + xmlResponse);
        
        objResponse = (Ter_SecurityTokenValidationResponse)Ter_BuilderXMLUtil_cls.xmlToSObject(xmlResponse, Ter_SecurityTokenValidationResponse.class);
        return objResponse;
    }
    
    public Ter_MemberValidationResponse invokeValidateMemberStr(String strSession, String strMemberId) {
        Ter_MemberValidationResponse objResponse;
        String xml;
        //xml = '<Envelope> <Header> <username>Bsf4g+Y/JxxDu1LAhncB0Q==</username> <password>njSzDmyvbifX1sHtUjxj2w==</password> </Header> <Body> <SecurityTokenValidationRequest> <token>0000034745201707241615340</token> <member_id>13428703035</member_id> <partner_code>TEPCO</partner_code> </SecurityTokenValidationRequest> </Body> </Envelope>';
        Ter_BuilderRequestGuest_cls.Ter_RequestGuestDTO_cls objRequestGuestDTO = new Ter_BuilderRequestGuest_cls.Ter_RequestGuestDTO_cls();
        
        objRequestGuestDTO.strSession = strSession;
        objRequestGuestDTO.strMemberId = strMemberId;
        
        Ter_BuilderRequestGuest_cls objBuilderRequestGuest  = new Ter_BuilderRequestGuest_cls();
        xml = objBuilderRequestGuest.builtValidateMember(objRequestGuestDTO);
        system.debug('=======>>>> xml: ' + xml);
        service.endpoint_x = this.customSettingsLifeMiles.TER_ENDPOINT_VM__c;
        service.timeout_x = Integer.ValueOf(this.customSettingsLifeMiles.TER_TIMEOUT__c); 
        system.debug('=======>>>> EndPoint: ' + service.endpoint_x); 
        system.debug('=======>>>> xmlRequest: ' + xml);
        
        String xmlResponse = service.validateMemberStr(xml);
        system.debug('=======>>>> xmlResponse: ' + xmlResponse);
        
        objResponse = (Ter_MemberValidationResponse)Ter_BuilderXMLUtil_cls.xmlToSObject(xmlResponse, Ter_MemberValidationResponse.class);
        return objResponse;
    }
}