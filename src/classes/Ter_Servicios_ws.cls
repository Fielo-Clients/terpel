global class Ter_Servicios_ws 
{
	webservice static TER_Response crearActualizarContrato( List<TER_Contrato> lstContrato )
	{
		return Ter_Contract_cls.crearContrato( lstContrato );
	}
	
	global class TER_Contrato
	{
		webservice String strNumContrato;
		webservice String strNombreContrato;
		webservice String strTituloContrato;
		webservice String strEstadoContrato;
		webservice String strCuentaContrato;
		webservice String strFechaIniContrato;
		webservice String strFechaFinContrato;
		webservice String strMoneda;
		//webservice String strLinkContrato;
		webservice Decimal decValorContrato;
	}
	
	global class TER_Response
	{
		webservice String strStatus;
		webservice String strCod;
		webservice String strMsg;
		
		global TER_Response(String strStatus, String strCod, String strMsg)
		{
			this.strStatus = strStatus;
			this.strCod = strCod;
			this.strMsg = strMsg;
		}
	}
}