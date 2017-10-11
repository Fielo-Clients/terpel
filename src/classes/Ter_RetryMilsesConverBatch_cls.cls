/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de ejecutar  el batch que reintenta la redencion
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		5/06/2017		Cristian Mosquera (CM)		Implementacion inicial del batch de reintentos.
**/
global class Ter_RetryMilsesConverBatch_cls implements Database.Batchable<sObject>, Database.AllowsCallouts{

     /** La utileria de cifrado. **/
    //private Ter_UtilEncriptacion_cls ter_utilEncriptacion_cls = new Ter_UtilEncriptacion_cls();

    /** Mapa con las authorizaciones a actualizar.**/
    //private static Map<String, Fielo_Autorizacion_LifeMiles__c> mapauthLifeMiles;
    
    private list<Fielo_Autorizacion_LifeMiles__c> lstAuthLifeMilesActualizar;

    /**
     * Metodo encargado de definirr el inicio del batch.
     * @param BC el contexto del batch.
     */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT ID,F_IdTransaccion__c,
        F_ReintentosConexionLM__c, F_Estado__c, F_TipoTransaccion__c, F_MillasBase__c,
        F_MillasPromocionales__c, F_Member__r.ID, F_AutorizacionLMPadre__c, F_NumeroLifeMiles__c
        FROM Fielo_Autorizacion_LifeMiles__c
        WHERE F_Estado__c  = :Label.TER_STATUS_RETRY_CONVERSION_WS]);
    }

    /**
     * Metodo encargado de ejecutar el batch.
     * @param BC el contexto del batch.
     * @param scope la lista con las autorizaciones pendientes por procesar.
     */
    global void execute(Database.BatchableContext BC, List<Fielo_Autorizacion_LifeMiles__c> lstAuthorizations)
    {
    	Ter_ConversionWsRequestDTO_cls request;
    	Ter_ConversionWsConsumer_cls conversionWsConsumer;
    	Ter_ConversionWsResponseDTO_cls response;
    	
        /*if (mapauthLifeMiles != null) {
            mapauthLifeMiles.clear();
        }
        
        mapauthLifeMiles = new Map<String, Fielo_Autorizacion_LifeMiles__c>(lstAuthorizations);*/
        
        lstAuthLifeMilesActualizar = new list<Fielo_Autorizacion_LifeMiles__c>();

        
        /*Fielo_ParametrosLifeMiles__c customSettingsLifeMiles =
                Fielo_ParametrosLifeMiles__c.getInstance('Ter_Custom_Settings_WS');*/
        
        /*Map<String, String> transactionTypes = new Map<String, String>();
        transactionTypes.put('Crédito (C)', 'C');
        transactionTypes.put('Débito (D)', 'D');
        transactionTypes.put('Reversión (R)', 'R');*/
        
        conversionWsConsumer = new Ter_ConversionWsConsumer_cls();

        for (Fielo_Autorizacion_LifeMiles__c objAuth : lstAuthorizations) {
            /*request = new Ter_ConversionWsRequestDTO_cls();
            request.setUsername( ter_utilEncriptacion_cls.encriptarAES256LifeMiles_B64
                    (customSettingsLifeMiles.TER_USERNAME__c));
            request.setPassword(ter_utilEncriptacion_cls.encriptarAES256LifeMiles_B64
                    (customSettingsLifeMiles.TER_PASSWORD__c));
            request.setTransactionId(objAuth.F_IdTransaccion__c);
            request.setMemberId(objAuth.F_Member__r.Id);
            request.setTransactionType(transactionTypes.get(objAuth.F_TipoTransaccion__c));
            request.setConversionMiles(objAuth.F_MillasBase__c);
            request.setPromotionalMiles(objAuth.F_MillasPromocionales__c);
            request.setSenderCode(customSettingsLifeMiles.TER_SENDER_CODE__c);
            request.setFieloAutorizacionLifeMilesId(objAuth.id);*/
            try {
                
                //response = conversionWsConsumer.invokeMilesConversion(request, mapauthLifeMiles);
                response = conversionWsConsumer.invokeMilesConversion(objAuth);
                system.debug('************ getResponseCode: ' + response.getResponseCode());
				if(label.Ter_lbl_Codigo_Exito_Merge_LM.equals(response.getResponseCode()) || 
						label.Ter_lbl_Codigo_Exito_Reintento_LM.equals(response.getResponseCode()) ||
						label.Ter_lbl_Codigo_Exito_Acumulacion_LM.equals(response.getResponseCode())){
	                objAuth.F_Estado__c = Label.TER_STATUS_SUCESS_CONVERSION_WS;
                } else if(label.Ter_lbl_Codigo_Rta_Reintentar.contains(response.getResponseCode())){
                	conversionWsConsumer.updateStatusAuthFielo(Label.TER_STATUS_RETRY_CONVERSION_WS, objAuth, response.getResponseCode());
                } else{
                	objAuth.F_Estado__c = Label.Ter_lbl_Estado_Rechazado;
                }
                objAuth.F_NumeroAutorizacionLM__c = response.getAuthoNum();
                objAuth.F_CodigoRespuestaLM__c = response.getResponseCode();
                objAuth.F_MillasBonus__c = response.getBonusMiles();
                lstAuthLifeMilesActualizar.add(objAuth);
            }
            catch (Exception e) {
                System.debug('Error -->' + e.getStackTraceString());
                System.debug('Error msg-->' + e.getMessage());
                
                //Si hubo excepcion el Autorizacion LifeMiles se dibio haber marcado 
                //para seguir en reintento y se le aumento el contador
                lstAuthLifeMilesActualizar.add(objAuth);
                continue;
            }

        }
        
    	if(lstAuthLifeMilesActualizar != null && !lstAuthLifeMilesActualizar.isEmpty()){
    		update lstAuthLifeMilesActualizar;
    	}
    }

    /**
     * Metodo que se ejecuta en el fin de la ejecucion de un batch.
     * @param BC contexto del batch.
     */
    global void finish(Database.BatchableContext BC)
    {
        /*for (Fielo_Autorizacion_LifeMiles__c objAuth : mapauthLifeMiles.values()) {
            update objAuth;
        }*/
    }

}