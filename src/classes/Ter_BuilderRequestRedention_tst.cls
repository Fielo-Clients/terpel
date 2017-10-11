/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de ejecutar  las pruebas de la la clase Ter_BuilderRequestRedention_cls
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		16/06/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
@isTest
public class Ter_BuilderRequestRedention_tst {

    /**
     * Metodo encargado de probar la funcionalidad del metodo built.
     */
    @isTest
    public static void testbuilt() {
        Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert cs;
        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert csp;
        Ter_BuilderRequestRedention_cls builderRequestRedention =
                new Ter_BuilderRequestRedention_cls();

        Ter_RequestRedentionDTO_cls request = new Ter_RequestRedentionDTO_cls();
        request.setMemberId('13428703035');
        request.setPartnerCode('44444');
        request.setUsername('cmosquera');
        request.setPassword('123456');
        request.setPostingAmount('100');
        request.setPostingEquivalent('4.85');
        request.setSession('0000113258');
        request.setTransactionDate('20160516');
        request.setTransactionDesc('Redencion de millas en Multiplaza');
        request.setTransactionType('645445');
        request.setTransactionId('abc00001');
        request.setPassword2('password segunda');
        request.setTransactionIdSource('Ts545454545');
        request.setDiscountAmount('500');
        List<Ter_RequestRedentionDTO_cls.AwardDTO> awards = new List<Ter_RequestRedentionDTO_cls.AwardDTO>();
        Ter_RequestRedentionDTO_cls.AwardDTO aw1 = new Ter_RequestRedentionDTO_cls.AwardDTO();
        aw1.setAwardCode('132555');
        aw1.setAwardName('Award1');
        aw1.setAwardDetail('detail aw1');
        Ter_RequestRedentionDTO_cls.AwardDTO aw2 = new Ter_RequestRedentionDTO_cls.AwardDTO();
        aw2.setAwardCode('254545');
        aw2.setAwardName('Award2');
        aw2.setAwardDetail('detail aw2');
        awards.add(aw1);
        awards.add(aw2);
        request.setAwards(awards);
        String xml = builderRequestRedention.built(request);
        System.assert(xml.contains('13428703035'));
        System.assert(xml.contains('TEPCO'));
        System.assert(xml.contains('njSzDmyvbifX1sHtUjxj2w=='));
        System.assert(xml.contains('Bsf4g+Y/JxxDu1LAhncB0Q=='));
        System.assert(xml.contains('100'));
        System.assert(xml.contains('4.85'));
        System.assert(xml.contains('0000113258'));
        System.assert(xml.contains('20160516'));
        System.assert(xml.contains('Redencion de millas en Multiplaza'));
        System.assert(xml.contains('645445'));
        System.assert(xml.contains('abc00001'));
        //System.assert(xml.contains('a11aed0ed04611c6ad6c30b4e7a2b3a68eb6181a331eaee168633e32cc778578'));
        System.assert(xml.contains('Ts545454545'));
        System.assert(xml.contains('500'));
        System.assert(xml.contains('132555'));
        System.assert(xml.contains('Award1'));
        System.assert(xml.contains('detail aw1'));
        System.assert(xml.contains('254545'));
        System.assert(xml.contains('Award2'));
        System.assert(xml.contains('detail aw2'));
        //String xml2 = '<Envelope><Header></Header><Body><PostingResponse><transaction_id></transaction_id><member_id></member_id><posting_amount></posting_amount><partner_code></partner_code><transaction_type></transaction_type><log_sequence>11936</log_sequence><response_code>001</response_code></PostingResponse></Body></Envelope>';
        //Ter_ResponseRedentionDTO_cls response = (Ter_ResponseRedentionDTO_cls)
        //        Ter_BuilderXMLUtil_cls.xmlToSObject(xml2, Ter_ResponseRedentionDTO_cls.class);
        //System.debug('response-->' + response);

        System.debug('XML-->' + xml);

    }
}