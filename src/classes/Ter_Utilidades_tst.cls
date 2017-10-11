/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase de pruebas para las clases de utilidades
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    28/06/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class Ter_Utilidades_tst {
    
        
    @isTest static void utilidades(){
        Configuracion_General__c objConfiguracion_General = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert objConfiguracion_General;
        
        Fielo_ParametrosLifeMiles__c objFielo_ParametrosLifeMiles = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert objFielo_ParametrosLifeMiles;
        
        list<Ter_Homologacion_Listas__c> lstHomologacion_Listas = Ter_DataGenerator_cls.crearDatosHomologados(true);
        list<Ter_Codigos_Errores__c> lstCodErrores = Ter_DataGenerator_cls.generarCodigosError(true);
        
        Test.startTest();
            
            Integer[] edadCompleta = Ter_Utilidades_cls.calcularEdadCompleta(Ter_Utilidades_cls.stringToDateLM('15-Jun-1980'));
            
            try{
                edadCompleta = Ter_Utilidades_cls.calcularEdadCompleta(Ter_Utilidades_cls.stringToDateLM('15-XXX-1980'));
            } catch(Ter_DateException e){
                //Nada
            }
            
            try{
                edadCompleta = Ter_Utilidades_cls.calcularEdadCompleta(Ter_Utilidades_cls.stringToDateLM('45-Jun-1980'));
            } catch(Ter_DateException e){
                //Nada
            }
            
            try{
                edadCompleta = Ter_Utilidades_cls.calcularEdadCompleta(Ter_Utilidades_cls.stringToDateLM('45-Jun-1980-xxx'));
            } catch(Ter_DateException e){
                //Nada
            }
            
            try{
                edadCompleta = Ter_Utilidades_cls.calcularEdadCompleta(Ter_Utilidades_cls.stringToDateLM('AA-Jun-1980'));
            } catch(Ter_DateException e){
                //Nada
            }
            Integer edad = Ter_Utilidades_cls.calcularEdad(Ter_Utilidades_cls.stringToDateLM('15-Jun-1980'));
            edad = Ter_Utilidades_cls.calcularEdad(Ter_Utilidades_cls.stringToDateLM('31-Jul-1980'));
            String  generarRandom = Ter_Utilidades_cls.generarRandom(4);
            String  obtenerTransaccionIdLifeMiles = Ter_Utilidades_cls.obtenerTransaccionIdLifeMiles();
            map<String, Ter_Homologacion_Listas__c> obtenerDatosHomologados =  Ter_Utilidades_cls.obtenerDatosHomologados(new set<String> { 'Fielo_Venta__c', 'FieloPLT__Member__c' });
            map<String, String> obtenerCodigosError =  Ter_Utilidades_cls.obtenerCodigosError('Acumulacion');
            Datetime stringToDatetime =  Ter_Utilidades_cls.stringToDatetime('2013-10-05 20:03:20');
            
            
            Ter_UtilEncriptacion_cls objEncrip = new Ter_UtilEncriptacion_cls();
            String e = objEncrip.encriptarAES256LifeMiles_Hex('www.url.com');
            String h = objEncrip.encriptarAES256LifeMiles_B64('www.url.com');
            String f = objEncrip.desencriptarAES256LifeMiles_B64(h);
            String g = objEncrip.desencriptarAES256_Hex(e);
            String a = Ter_UtilEncriptacion_cls.cifradoURL3D('www.url.com');
            String b = Ter_UtilEncriptacion_cls.decifradoURL3D('www.url.com');
            String c = Ter_UtilEncriptacion_cls.calcularSHA1('www.url.com');
            String d = Ter_UtilEncriptacion_cls.calcularSHA256('www.url.com');
            
            Ter_XmlToJson_cls objJson = new Ter_XmlToJson_cls();
            objJson.xmlText = '<ClienteRespuesta> <codigoRespuestas>0</codigoRespuestas> <MensajeRespuesta>Transacción exitosa</MensajeRespuesta> <fechaRespuesta>2017-06-27 09:46:55</fechaRespuesta> </ClienteRespuesta>';
            //objJson.xmlText = '<ClienteRespuesta><codigoRespuestas>0</codigoRespuestas><MensajeRespuesta>Transacción exitosa</MensajeRespuesta><fechaRespuesta>2017-06-27 09:46:55</fechaRespuesta><objComplejo><dato1>el dato</dato1><dato2>el segundo dato</dato2></objComplejo></ClienteRespuesta>';
            objJson.getJsonText();
            Ter_XmlToJson_cls.parseDocumentToObject('<ClienteRespuesta><codigoRespuestas>0</codigoRespuestas><MensajeRespuesta>Transacción exitosa</MensajeRespuesta><fechaRespuesta>2017-06-27 09:46:55</fechaRespuesta><objComplejo><dato1>el dato</dato1><dato2>el segundo dato</dato2></objComplejo></ClienteRespuesta>', RootObject.class);
            
            Dom.Document document = new Dom.Document();
        	document.load(objJson.xmlText);
        	
        	objJson.xmlText = '46545';
            objJson.getJsonText();
            
            Ter_ResponseRedentionDTO_cls objResponseRedentionDTO =  new Ter_ResponseRedentionDTO_cls();
            Ter_ResponseRedentionDTO_cls.Body objBody = new Ter_ResponseRedentionDTO_cls.Body();
            Ter_ResponseRedentionDTO_cls.PostingResponse postingResponse = new Ter_ResponseRedentionDTO_cls.PostingResponse();
            
            postingResponse.setTransaction_id(null);
            postingResponse.setMember_id(null);
            postingResponse.setPosting_amount (null);
            postingResponse.setPartner_code  (null);
            postingResponse.setTransaction_type   (null);
            postingResponse.setLog_sequence(null);
            postingResponse.setResponse_code(null);
            
            postingResponse.getTransaction_id();
            postingResponse.getMember_id();
            postingResponse.getPosting_amount ();
            postingResponse.getPartner_code  ();
            postingResponse.getTransaction_type   ();
            postingResponse.getLog_sequence();
            postingResponse.getResponse_code();
            
            objBody.setPostingResponse(postingResponse);
            objBody.getPostingResponse();
            
            objResponseRedentionDTO.setBody(objBody);
            objResponseRedentionDTO.getBody();
        Test.stopTest();
    }
    
	public class ObjComplejo
	{
	    public string dato1 { get; set; }
	    public string dato2 { get; set; }
	}
	
	public class ClienteRespuesta
	{
	    public string codigoRespuestas { get; set; }
	    public string MensajeRespuesta { get; set; }
	    public string fechaRespuesta { get; set; }
	    public ObjComplejo objComplejo { get; set; }
	}
	
	public class RootObject
	{
	    public ClienteRespuesta ClienteRespuesta { get; set; }
	}
    
}