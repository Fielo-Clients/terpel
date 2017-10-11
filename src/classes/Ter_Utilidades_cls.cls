/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase de utilidades para el manejo de datos
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    18/05/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class Ter_Utilidades_cls {
	
	private static final String SEPARADOR_FECHA_LM = '-';
	
	private static map<String, Integer> mapMeses = new map<String, Integer>{'JAN'=>1, 'FEB'=>2, 'MAR'=>3, 'APR'=>4, 'MAY'=>5, 'JUN'=>6, 'JUL'=>7, 'AUG'=>8, 'SEP'=>9, 'OCT'=>10, 'NOV'=>11, 'DEC'=>12,
																	 'ENE'=>1, 'FEB'=>2, 'MAR'=>3, 'ABR'=>4, 'MAY'=>5, 'JUN'=>6, 'JUL'=>7, 'AGO'=>8, 'SEP'=>9, 'OCT'=>10, 'NOV'=>11, 'DIC'=>12};
	
	public static final String FORMATO_FECHA_TRANSACTION_ID = 'YYYYMMddHHmmssSSS';
	
	/* 
	* Nombre: stringToDateLM
    * Descripcion: Metodo encargado de parsear una fecha que este en String en 
    * 			   formato DD-MMM-YYYY y la convierte en un objeto tipo Date.
    * Fecha Creación: 18/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            18-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static Date stringToDateLM(String strFecha){
		Date dtFecha;
		String[] arrayFecha = strFecha.split(SEPARADOR_FECHA_LM);
		if(arrayFecha.size() != 3){
			//La fecha no llego con el formato correcto
			throw new Ter_DateException('<<StringToDate>> La fecha no llegó con el formato correcto (3 campos DD-MMM-YYYY).');
		} else{
			if(mapMeses.containsKey(arrayFecha[1].toUpperCase())){
				try{
					return  Date.newinstance(Integer.valueOf(arrayFecha[2]), mapMeses.get(arrayFecha[1].toUpperCase()), Integer.valueOf(arrayFecha[0]));
				} catch(Exception e){
					System.Debug('====================== EXCEPCION [StringToDate] ======================');
		    		System.debug( e.getMessage() + ' ' + e.getStackTraceString());
		    		System.Debug('======================================================================');
		    		throw new Ter_DateException('<<StringToDate>> Error creando fecha: ' + e.getMessage());
				}
			} else{
				//El map no contiene el mes que llego en la fecha
				throw new Ter_DateException('<<StringToDate>> El mes no se puede identificar.');
			}
		}
	}
	
	/* 
	* Nombre: calcularEdad
    * Descripcion: Metodo encargado calcular el numero de años de una fecha hasta el dia de hoy
    * Fecha Creación: 18/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            18-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static Integer calcularEdad(Date dtFechaNacimiento){
		Integer intEdad, intTotalDias;
		
		intTotalDias = dtFechaNacimiento.daysBetween(system.today());
		intEdad = (Integer)(Math.Floor(intTotalDias/365.2425));
		return intEdad;
	}
	
	/* 
	* Nombre: calcularEdadCompleta
    * Descripcion: Metodo encargado calcular el numero de años, meses y dias de una fecha hasta el dia de hoy
    * 			   https://developer.salesforce.com/forums/?id=906F000000091ZwIAI
    * Fecha Creación: 18/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            18-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static Integer[] calcularEdadCompleta(Date dtFechaNacimiento){
		Integer intEdad, intMeses, intDias, intTotalDias;
		Integer[] intEdadCompleta = new Integer[3];
		//TO FIND THE AGE
		intTotalDias = dtFechaNacimiento.daysBetween(system.today());
		intEdad = (integer)(math.Floor(intTotalDias/365.2425));
		
		// TO FIND THE MONTHS
		if(dtFechaNacimiento.day()<=(system.today().day())){
			intMeses = system.today().month() - dtFechaNacimiento.month();
		} else {
			intMeses=system.today().month()-dtFechaNacimiento.month()-1;
		}
		
		if(intMeses < 0){
			intMeses = intMeses +12;
		}
		
		//TO FIND THE REMAINING DAYS
		if((system.today().day() == dtFechaNacimiento.day()) || (system.today().day() > dtFechaNacimiento.day())){
			intDias = system.today().day() - dtFechaNacimiento.day();
		} else {
			if(math.mod(system.today().month(),2)==0){
				intDias = 31 - (dtFechaNacimiento.day() - system.today().day());
			} else {
				intDias = 30 - (dtFechaNacimiento.day() - system.today().day());
			}
		}
		
		system.debug('Total dias: ' + intTotalDias + ', Edad: ' + intEdad + ', Meses: ' + intMeses + ', Dias: ' + intDias);
		intEdadCompleta[0] = intEdad;
		intEdadCompleta[1] = intMeses;
		intEdadCompleta[2] = intDias;
		return intEdadCompleta;
	}
	
	/* 
	* Nombre: obtenerDatosHomologados
    * Descripcion: Metodo encargado de obtener los valores de campos a homologar de una lista de objetos
    * Fecha Creación: 20/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            20-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static map<String, Ter_Homologacion_Listas__c> obtenerDatosHomologados(set<String> lstNombresObjetos){
		List<Ter_Homologacion_Listas__c> lstHomologacion = new List<Ter_Homologacion_Listas__c>();
		map<String, Ter_Homologacion_Listas__c> mapHomologacion;
		String strLlave;
		
		lstHomologacion = [SELECT Ter_Campo__c, Ter_Objeto__c, Ter_Valor_Externo__c, Ter_Valor_Homologado__c FROM Ter_Homologacion_Listas__c WHERE Ter_Objeto__c IN :lstNombresObjetos];
		
		if(!lstHomologacion.isEmpty()){
			mapHomologacion = new map<String, Ter_Homologacion_Listas__c>();
			for(Ter_Homologacion_Listas__c objHomologacionListas : lstHomologacion){
				strLlave = objHomologacionListas.Ter_Objeto__c + 
					objHomologacionListas.Ter_Campo__c + 
					objHomologacionListas.Ter_Valor_Externo__c;
				mapHomologacion.put(strLlave, objHomologacionListas);
			}
			return mapHomologacion;
		} else{
			return null;
		}
	}
	
	/* 
	* Nombre: obtenerCodigosError
    * Descripcion: Metodo encargado consultar los codigos de error en la configuracion personalizada para un proceso especifico
    * Fecha Creación: 14/20/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            20-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static map<String, String> obtenerCodigosError(String strProceso){
		List<Ter_Codigos_Errores__c> lstCodigosErrores = new List<Ter_Codigos_Errores__c>();
		map<String, String> mapCodigosError;
		String strLlave;
		
		lstCodigosErrores = [SELECT Ter_Codigo_Error__c, Ter_Mensaje__c FROM Ter_Codigos_Errores__c WHERE Ter_Proceso__c = :strProceso];
		
		if(!lstCodigosErrores.isEmpty()){
			mapCodigosError = new map<String, String>();
			for(Ter_Codigos_Errores__c objCodigosErrores : lstCodigosErrores){
				mapCodigosError.put(objCodigosErrores.Ter_Codigo_Error__c, objCodigosErrores.Ter_Mensaje__c);
			}
			return mapCodigosError;
		} else{
			return new map<String, String>();
		}
	}
	
	/* 
	* Nombre: obtenerFechaActualFormateadaStr
    * Descripcion: Metodo encargado de retornar la fecha actual del sistema en un formato dado
    * Fecha Creación: 14/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            14-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static String obtenerFechaActualFormateadaStr(String strFormato){
		DateTime dt = DateTime.now();
    	return dt.format(strFormato);
	}
	
	/* 
	* Nombre: stringToDatetime
    * Descripcion: Metodo encargado convertir una fecha String en un Datetime, la fecha 
    * 			   debe de venir en formato yyyy-MM-dd HH:mm:ss
    * Fecha Creación: 14/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            14-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static Datetime stringToDatetime(String strDatetime){
		try {
			strDatetime = strDatetime.trim().replace('T', ' ');
			return datetime.valueOf(strDatetime);
		} catch (Exception e) {
			return null;
		}
	}
	
	/* 
	* Nombre: generarRandom
    * Descripcion: Metodo encargado de generar numero aleatorio del tamaño recibido en el parametro
    * Fecha Creación: 28/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            28-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static String generarRandom(Integer intLen){
		String str = string.valueof(Math.abs(Crypto.getRandomLong()));
		return str.substring(0, intLen);
	}
	
	/* 
	* Nombre: obtenerTransaccionIdLifeMiles
    * Descripcion: Metodo encargado de generar un TransaccionId para enviar a LifeMiles
    * Fecha Creación: 28/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            28-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static String obtenerTransaccionIdLifeMiles(){
		String strTransaccionId;
		
		strTransaccionId = obtenerFechaActualFormateadaStr(FORMATO_FECHA_TRANSACTION_ID) + generarRandom(3);
		
		return strTransaccionId;
	}
	
	/* 
	* Nombre: obtenerTransaccionIdLifeMiles
    * Descripcion: Metodo encargado de formatear una fecha tipo Datetime en yyyyMMddHHmmss
    * Fecha Creación: 27/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            27-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static String formatearFecha(Datetime dt){
		return dt.format('yyyyMMddHHmmss');
	}
	
	/* 
	* Nombre: generarIdVentaTDC
    * Descripcion: Metodo encargado de generar un IdVenta para las redenciones en TDC
    * Fecha Creación: 22/09/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            22-Sep-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public static String generarIdVentaTDC(){
		String strIdVentaGenerado;
		
		strIdVentaGenerado = generarRandom(4) + obtenerFechaActualFormateadaStr(FORMATO_FECHA_TRANSACTION_ID);
		
		return strIdVentaGenerado;
	}
	
}