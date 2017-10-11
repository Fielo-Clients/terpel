/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe responsable de simular una respuesta del servicio de redención
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		1/06/2017		Cristian Mosquera (CM)		Implementacion inicial del mock.
**/
@isTest
global class Ter_ConversionWsMock_cls implements WebServiceMock {
	String codRespuesta {get; set;}
	
	public Ter_ConversionWsMock_cls(){
	}
	
	public Ter_ConversionWsMock_cls(String codRespuesta){
		this.codRespuesta = codRespuesta;
	}
	
    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
        Ter_LifMilesConversionService_cls.PostMilesConversionResponse_element response_x =
                new Ter_LifMilesConversionService_cls.PostMilesConversionResponse_element();
        Ter_LifMilesConversionSchemas_cls.ResEnvelope resEnvvelope =
                            new Ter_LifMilesConversionSchemas_cls.ResEnvelope();
        Ter_LifMilesConversionSchemas_cls.ResBody body =
                            new Ter_LifMilesConversionSchemas_cls.ResBody();
        body.bonus_miles = 50;
        body.conversion_miles = 1000;
        body.autho_num = '55545';
        body.lifemiles_number = '123456';
        body.member_id = '554545';
        body.prepurchase_trans = '54545';
        body.promotional_miles = 300;
        body.transaction_id = '19871030105410000010';
        body.transaction_id_source = '19871030105410000010';
        body.transaction_type = 'C';
        if(codRespuesta == null){
        	body.response_code = '000';
        } else{
        	system.debug('************ codRespuesta: ' + codRespuesta);
        	body.response_code = this.codRespuesta;
        }
        resEnvvelope.body = body;
        response_x.PostMilesConversionResult = resEnvvelope;
        response.put('response_x', response_x);
    }
}