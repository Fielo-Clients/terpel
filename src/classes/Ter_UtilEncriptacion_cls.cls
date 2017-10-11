/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase de utilidades con la logica para encriptar y desenciptar
					datos usando el algoritmo AES256 CBC
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    15/05/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class Ter_UtilEncriptacion_cls {
	
	private final String AES256 = 'AES256';
	private static final String UTF8 = 'UTF-8';
	private final String NO_APLICA = 'N/A';
	
	private Map<string, Configuracion_General__c> mapConfiguracionGeneral;
	
	/*
	* Nombre: Ter_UtilEncriptacion_cls
    * Descripcion: Constructor de la clase que inicializar la configuración personalizada
    *			   la cual contiene los parametros generale
    * Fecha Creación: 15/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            15-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public Ter_UtilEncriptacion_cls(){
		this.mapConfiguracionGeneral = Configuracion_General__c.getAll();
	}

	
	/* 
	* Nombre: encriptarAES256LifeMiles_B64
    * Descripcion: Metodo encargado de encriptar una cadena de texto usando el algorimo AES256 y 
    * 			   retornar el resultado cifrado en Base64
    * Fecha Creación: 15/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            15-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public String encriptarAES256LifeMiles_B64(String datoLimpio){
		return EncodingUtil.base64Encode(encriptarAES256_LifeMiles(datoLimpio)); 
	}
	
	/* 
	* Nombre: encriptarAES256LifeMiles_Hex
    * Descripcion: Metodo encargado de encriptar una cadena de texto usando el algorimo AES256 y 
    * 			   retornar el resultado cifrado en Hexadecimal
    * Fecha Creación: 15/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            15-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public String encriptarAES256LifeMiles_Hex(String datoLimpio){
		return EncodingUtil.convertToHex(encriptarAES256_LifeMiles(datoLimpio)); 
	}
	
	/* 
	* Nombre: encriptarAES256
    * Descripcion: Metodo encargado de encriptar una cadena de texto usando el algorimo AES256
    * Fecha Creación: 15/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            15-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	private Blob encriptarAES256_LifeMiles(String datoLimpio){
		if(mapConfiguracionGeneral.containsKey(label.Ter_lbl_CP_General)
				&& mapConfiguracionGeneral.get(label.Ter_lbl_CP_General).Ter_IV_AES_LifeMiles__c != null
				&& mapConfiguracionGeneral.get(label.Ter_lbl_CP_General).Ter_Llave_AES_LifeMiles__c != null){
			Blob blbIV = Blob.valueOf(mapConfiguracionGeneral.get(label.Ter_lbl_CP_General).Ter_IV_AES_LifeMiles__c);
			Blob blbKey = Blob.valueOf(mapConfiguracionGeneral.get(label.Ter_lbl_CP_General).Ter_Llave_AES_LifeMiles__c);
			Blob blbData = Blob.valueOf(datoLimpio);
			Blob blbEncriptado = Crypto.encrypt(AES256, blbKey, blbIV, blbData);
			return blbEncriptado; 
		} else{
			throw new Ter_AESException('<<Encriptar>> No hay llave o IV parametrizado.');
		}
	}
	
	/* 
	* Nombre: desencriptarAES256LifeMiles_B64
    * Descripcion: Metodo encargado de desencriptar una cadena de texto codificada en Base 64 
    * 			   usando el algorimo AES256
    * Fecha Creación: 15/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            15-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public String desencriptarAES256LifeMiles_B64(String strDataEncriptada){
		return desencriptarAES256_LifeMiles(EncodingUtil.base64Decode(strDataEncriptada));
	}
	
	/* 
	* Nombre: desencriptarAES256_Hex
    * Descripcion: Metodo encargado de desencriptar una cadena de texto codificada en Hexadecimal 
    * 			   usando el algorimo AES256
    * Fecha Creación: 15/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            15-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public String desencriptarAES256_Hex(String strDataEncriptada){
		return desencriptarAES256_LifeMiles(EncodingUtil.convertFromHex(strDataEncriptada));
	}
	
	/* 
	* Nombre: desencriptarAES256
    * Descripcion: Metodo encargado de desencriptar una cadena de texto usando el algorimo AES256
    * Fecha Creación: 15/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            15-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	private String desencriptarAES256_LifeMiles(Blob blbDataEncriptada){
		if(mapConfiguracionGeneral.containsKey(label.Ter_lbl_CP_General) 
				&& mapConfiguracionGeneral.get(label.Ter_lbl_CP_General).Ter_IV_AES_LifeMiles__c != null
				&& mapConfiguracionGeneral.get(label.Ter_lbl_CP_General).Ter_Llave_AES_LifeMiles__c != null){
			Blob blbIV = Blob.valueOf(mapConfiguracionGeneral.get(label.Ter_lbl_CP_General).Ter_IV_AES_LifeMiles__c);
			Blob blbKey = Blob.valueOf(mapConfiguracionGeneral.get(label.Ter_lbl_CP_General).Ter_Llave_AES_LifeMiles__c);
			Blob blbDecrypted = Crypto.decrypt(AES256, blbKey, blbIV, blbDataEncriptada);
			return blbDecrypted.toString();
		} else{
			throw new Ter_AESException('<<Desencriptar>> No hay llave o IV parametrizado.');
		}	
	}
	
	/* 
	* Nombre: cifradoURL3D
    * Descripcion: Metodo encargado de cifrar una URL en el formato 3D
    * Fecha Creación: 17/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            17-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static String cifradoURL3D(String strURL){
		return EncodingUtil.urlEncode(strURL, UTF8);
	}
	
	/* 
	* Nombre: decifradoURL3D
    * Descripcion: Metodo encargado de decifrar una URL en el formato 3D
    * Fecha Creación: 17/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            17-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static String decifradoURL3D(String strURL){
		return EncodingUtil.urlDecode(strURL, UTF8);
	}
	
	/* 
	* Nombre: calcularSHA1
    * Descripcion: Metodo encargado de calcular una Hash en SHA1 para una cadena de texto
    * Fecha Creación: 25/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            25-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static String calcularSHA1(String strTexto){
		return EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', Blob.valueOf(strTexto)));
	} 
	
	/* 
	* Nombre: calcularSHA1
    * Descripcion: Metodo encargado de calcular una Hash en SHA256 para una cadena de texto
    * Fecha Creación: 21/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            21-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static String calcularSHA256(String strTexto){
		return EncodingUtil.convertToHex(Crypto.generateDigest('SHA256', Blob.valueOf(strTexto)));
	} 
	
	/* 
	* Nombre: desencriptarAES256_Registro
    * Descripcion: Metodo encargado de descifrar una cadena de texto y validarlo
    * Fecha Creación: 14/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            14-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public String desencriptarAES256_Registro(String strDataEncriptada){
		String strDatoDesencriptado =  desencriptarAES256_LifeMiles(EncodingUtil.base64Decode(strDataEncriptada));
		if(strDatoDesencriptado.equals(NO_APLICA)){
			return null;
		} else{
			return strDatoDesencriptado;
		}
	}
	
	
	/* 
	* Nombre: desencriptarAES256LifeMiles_B64
    * Descripcion: Metodo encargado de desencriptar una cadena de texto codificada en Base 64 
    * 			   usando el algorimo AES256
    * Fecha Creación: 06/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            06-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public String desencriptarAES256Terpel_B64(String strDataEncriptada){
		return desencriptarAES256_Terpel(EncodingUtil.base64Decode(strDataEncriptada));
	}
	
	/* 
	* Nombre: desencriptarAES256_Terpel
    * Descripcion: Metodo encargado de desencriptar una cadena de texto usando el algorimo AES256 y la llave y el vector de Terpel
    * Fecha Creación: 06/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            06-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	private String desencriptarAES256_Terpel(Blob blbDataEncriptada){
		Configuracion_General__c objConfGeneral;
		
		objConfGeneral = mapConfiguracionGeneral.get(label.Ter_lbl_CP_General);
		if(objConfGeneral != null 
				&& objConfGeneral.Ter_IV_AES_Terpel__c != null
				&& objConfGeneral.Ter_Llave_AES_LifeMiles__c != null){
			Blob blbIV = Blob.valueOf(objConfGeneral.Ter_IV_AES_Terpel__c);
			Blob blbKey = Blob.valueOf(objConfGeneral.Ter_Llave_AES_Terpel__c);
			Blob blbDecrypted = Crypto.decrypt(AES256, blbKey, blbIV, blbDataEncriptada);
			return blbDecrypted.toString();
		} else{
			throw new Ter_AESException('<<Desencriptar>> No hay llave o IV parametrizado.');
		}	
	}
	
	/* 
	* Nombre: encriptarAES256LifeMiles_B64
    * Descripcion: Metodo encargado de encriptar una cadena de texto usando el algorimo AES256 y 
    * 			   retornar el resultado cifrado en Base64
    * Fecha Creación: 06/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            07-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public String encriptarAES256Terpel_B64(String datoLimpio){
		return EncodingUtil.base64Encode(encriptarAES256_Terpel(datoLimpio)); 
	}
	
	/* 
	* Nombre: encriptarAES256
    * Descripcion: Metodo encargado de encriptar una cadena de texto usando el algorimo AES256 y la llave y el vector de Terpel
    * Fecha Creación: 06/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            06-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	private Blob encriptarAES256_Terpel(String datoLimpio){
		Configuracion_General__c objConfGeneral;
		
		objConfGeneral = mapConfiguracionGeneral.get(label.Ter_lbl_CP_General);
		if(objConfGeneral != null 
				&& objConfGeneral.Ter_IV_AES_Terpel__c != null
				&& objConfGeneral.Ter_Llave_AES_LifeMiles__c != null){
			Blob blbIV = Blob.valueOf(objConfGeneral.Ter_IV_AES_Terpel__c);
			Blob blbKey = Blob.valueOf(objConfGeneral.Ter_Llave_AES_Terpel__c);
			Blob blbData = Blob.valueOf(datoLimpio);
			Blob blbEncriptado = Crypto.encrypt(AES256, blbKey, blbIV, blbData);
			return blbEncriptado; 
		} else{
			throw new Ter_AESException('<<Encriptar>> No hay llave o IV parametrizado.');
		}
	}
	
}