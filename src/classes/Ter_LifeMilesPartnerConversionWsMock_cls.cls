/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de simular una respuesta del websevice de redencion.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		20/06/2017		Cristian Mosquera (CM)		Implementacion inicial la clase.
**/
@isTest
global class Ter_LifeMilesPartnerConversionWsMock_cls implements WebServiceMock {

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
        Ter_LifeMilesComPartnersService_cls.postMilesStrResponse_element response_x =
                new Ter_LifeMilesComPartnersService_cls.postMilesStrResponse_element();

        response_x.postMilesStrResult = '<Envelope>'
                + '<Header></Header>'
                + '<Body>'
                + '<PostingResponse>'
                + '<transaction_id> 545454</transaction_id>'
                + '<member_id>54554</member_id>'
                + '<posting_amount>455</posting_amount>'
                + '<partner_code>5454</partner_code>'
                + '<transaction_type>D</transaction_type>'
                + '<log_sequence>11936</log_sequence>'
                + '<response_code>000</response_code>'
                + '</PostingResponse>'
                + '</Body>'
                + '</Envelope>';
        response.put('response_x', response_x);
    }
}