/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez (WRM)
Proyecto: Terpel
Descripción: Clase que se encargara de las validaciones y las creaciones sobre el objeto contrato. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 23-01-2017  Walter Rodríguez M (WRM)      Creación de la Clase.
***********************************************************************************/

public class Ter_Contract_cls
{
	public String strNumContrato;
	public String strNombreContrato;
	public String strTituloContrato;
	public String strEstadoContrato;
	public String strCuentaContrato;
	public String strValorContrato;
	public String strFechaIniContrato;
	public String strFechaFinContrato;
	public String strMoneda;
	//public String strLinkContrato;
	
	public Ter_Contract_cls()
	{
		strNumContrato = '';
		strNombreContrato = '';
		strTituloContrato = '';
		strEstadoContrato = '';
		strCuentaContrato = '';
		strValorContrato = '';
		strFechaIniContrato = '';
		strFechaFinContrato = '';
		strMoneda = '';
		//strLinkContrato = '';
	}
	
	public void crearOportunidad( List<Contract>lstOldContract, List<Contract>lstNewContract )
	{
		if( lstOldContract[0].Ter_Generar_Oportunidad__c != lstNewContract[0].Ter_Generar_Oportunidad__c)
		{
			if( lstNewContract[0].Ter_Generar_Oportunidad__c )
			{
				Opportunity objOpp = new Opportunity();
				objOpp.Name = ' Renovación Contrato ' + lstNewContract[0].Name;
				objOpp.AccountId = lstNewContract[0].AccountId;
				objOpp.ContractId = lstNewContract[0].Id;
				objOpp.StageName = 'Visita';
				objOpp.CloseDate = system.today().addMonths(1);
				
				try
				{
					lstNewContract[0].Ter_Generar_Oportunidad__c = false;
					insert objOpp;
				}
				catch(system.exception e)
				{
					system.debug('Error --> ' + e);
					ApexPages.addMessages(e); 
				}
				
				Task objTask = new Task();
				objTask.Subject = 'Call';
				objTask.WhatId = objOpp.Id;
				objTask.ActivityDate = system.today().addMonths(1);
				for(Account objAcc : [select Id, (select Id from Contacts limit 1) from Account where Id =: lstNewContract[0].AccountId])
				{	
					if(!objAcc.Contacts.isEmpty() && objAcc.Contacts != null)
						objTask.WhoId = objAcc.Contacts[0].Id;
				}
				try
				{
					insert objTask;
				}
				catch(system.exception e)
				{
					system.debug('Error --> ' + e);
					ApexPages.addMessages(e); 
				}
			}
		}
	}
	
	public static TER_Servicios_ws.TER_Response crearContrato( List<TER_Servicios_ws.TER_Contrato> lstContrato)
	{
		set<String>setNumContrato = new set<String>();
		set<String>setNombreCuenta = new set<String>();
		map<String, Contract> mapContrato = new map<String, Contract>();
		map<String, Account> mapCuenta = new map<String, Account>();
		list<Contract> lstContratoActualizar = new list<Contract>();
		Contract objContract;
		TER_Servicios_ws.TER_Response objResp;
		
		for(TER_Servicios_ws.TER_Contrato objCon : lstContrato)
		{
			setNumContrato.add(objCon.strNumContrato);
			setNombreCuenta.add(objCon.strCuentaContrato);
		}
		
		list<Contract> lstCont = [Select id, Ter_Numero_de_contrato__c From contract Where Ter_Numero_de_contrato__c IN: setNumContrato];
		String strVar = '[Select id, Ter_Numero_de_contrato__c From contract Where Ter_Numero_de_contrato__c IN:' + setNumContrato + ']';
		system.debug('strVar --> ' + strVar);
		if(!lstCont.isEmpty())
		{
			for(Contract contr : lstCont)
			{
				mapContrato.put(contr.Ter_Numero_de_contrato__c, contr);
			}
		}
		system.debug('setNombreCuenta --> ' + setNombreCuenta);
		//list<Account> lstAcc = [Select id, Name, AccountNumber From account Where Name IN: setNombreCuenta];
		list<Account> lstAcc = [Select id, Name, AccountNumber From account Where AccountNumber IN: setNombreCuenta];
		
		if(!lstAcc.isEmpty())
		{
			for(Account objAcc : lstAcc)
			{
				//mapCuenta.put(objAcc.Name, objAcc);
				mapCuenta.put(objAcc.AccountNumber, objAcc);
			}
		}
		system.debug('mapCuenta --> ' + mapCuenta);
		for(TER_Servicios_ws.TER_Contrato objContrato : lstContrato)
		{
			if(mapContrato.containsKey(objContrato.strNumContrato))
			{
				objContract = mapContrato.get(objContrato.strNumContrato);
				objContract.Ter_Numero_de_contrato__c = objContrato.strNumContrato;
				objContract.Name = objContrato.strNombreContrato;
				objContract.Status = objContrato.strEstadoContrato;
				objContract.Ter_Titulo__c = objContrato.strTituloContrato;
				objContract.Ter_Valor_del_Contrato__c = objContrato.decValorContrato;
				objContract.StartDate = date.parse(objContrato.strFechaIniContrato);
				objContract.Ter_Fecha_de_Fin__c = date.parse(objContrato.strFechaFinContrato);
				objContract.Ter_Moneda__c = objContrato.strMoneda;
				//objContract.Ter_Link_para_Detalle__c = objContrato.strLinkContrato;
				if(mapCuenta.containsKey(objContrato.strCuentaContrato))
					objContract.AccountId = mapCuenta.get(objContrato.strCuentaContrato).Id;
				else
				{
					objResp = new TER_Servicios_ws.TER_Response('FAIL', '1', 'No existe la cuenta ' + objContrato.strCuentaContrato + ' para el contrato ' + objContrato.strNumContrato);
					break;
				}
			}
			else
			{
				objContract = new Contract();
				objContract.Ter_Numero_de_contrato__c = objContrato.strNumContrato;
				objContract.Name = objContrato.strNombreContrato;
				objContract.Status = objContrato.strEstadoContrato;
				objContract.Ter_Titulo__c = objContrato.strTituloContrato;
				objContract.Ter_Valor_del_Contrato__c = objContrato.decValorContrato;
				objContract.StartDate = date.parse(objContrato.strFechaIniContrato);
				objContract.Ter_Fecha_de_Fin__c = date.parse(objContrato.strFechaFinContrato);
				objContract.Ter_Moneda__c = objContrato.strMoneda;
				//objContract.Ter_Link_para_Detalle__c = objContrato.strLinkContrato;
				if(mapCuenta.containsKey(objContrato.strCuentaContrato))
					objContract.AccountId = mapCuenta.get(objContrato.strCuentaContrato).Id;
				else
					objResp = new TER_Servicios_ws.TER_Response('FAIL', '1', 'No existe la cuenta ' + objContrato.strCuentaContrato + ' para el contrato ' + objContrato.strNumContrato);
			}
			lstContratoActualizar.add(objContract);
		}
		if(objResp == null)
		{
			try
			{
				system.debug('lstContratoActualizar --> ' + lstContratoActualizar);
				//Schema.SObjectField key = Contract.Fields.Ter_Numero_de_contrato__c;
				//Database.upsert(lstContratoActualizar, key, false);
				upsert lstContratoActualizar;
				objResp = new TER_Servicios_ws.TER_Response('OK', '0', 'Se a creado y/o actualizado todos los contratos satisfactoriamente.');
			}
			catch(system.exception e)
			{
				system.debug('Error --> ' + e);
				return new TER_Servicios_ws.TER_Response('FAIL','2', e.getmessage());
			}
		}
		
		return objResp;
		/*TER_Servicios_ws.TER_Response objResp;
		Contract objContract = new Contract();
		Sobject theObject = (Sobject)objContract;
		system.debug('objContrato --> ' + objContrato);
		for(TER_Servicios_ws.TER_Atributo atributo : objContrato.lstAtributos)
		{
			objResp = validaDatosObligatorios(atributo);
			Object objValue = atributo.strValor;
			theObject.put(atributo.strApi, objValue);
			System.debug('theObject ' + theObject);
		}
		if(objResp != null)
			return objResp;
		else
		{
			objContract.Ter_Numero_de_contrato__c = strNumContrato;
			objContract.Name = strNombreContrato;
			objContract.Status = strEstadoContrato;
			objContract.Ter_Titulo__c = strTituloContrato;
			objContract.Ter_Valor_del_Contrato__c = decimal.valueOf(strValorContrato);
			objContract.StartDate = date.valueOf(strFechaIniContrato);
			objContract.Ter_Fecha_de_Fin__c = date.valueOf(strFechaFinContrato);
			objContract.Ter_Fecha_de_Fin__c = strLinkContrato;
			
			List<Account>lstIdCuenta = [Select id from Account where Name =: strCuentaContrato];
			if(!lstIdCuenta.isEmpety())
				objContract.AccountId = lstIdCuenta[0].id;
				
			List<COntract>lstContract = [Select id from Contract where Ter_Numero_de_contrato__c =: strNumContrato];
			if(lstContract.isEmpty())
				insert objContract;
		}*/
		//return null;
	}
	
	/*private static TER_Servicios_ws.TER_Response validaDatosObligatorios( TER_Servicios_ws.TER_Atributo atributo )
	{
		
		if(atributo.strApi == 'AccountId')
		{
			if(atributo.strValor == '' || atributo.strValor == null)
				return new TER_Servicios_ws.TER_Response('FAIL','2','EL VALOR CUENTA ES OBLIGATORIO');
			else
				strCuentaContrato = atributo.strValor;
		}
		if(atributo.strApi == 'Ter_Numero_de_contrato__c')
		{
			if(atributo.strValor == '' || atributo.strValor == null)
				return new TER_Servicios_ws.TER_Response('FAIL','2','EL VALOR NÚMERO DEL CONTRATO ES OBLIGATORIO');
			else
			 strNumContrato = atributo.strValor;
		}
		if(atributo.strApi == 'Name')
		{
			if(atributo.strValor == '' || atributo.strValor == null)
				return new TER_Servicios_ws.TER_Response('FAIL','2','EL VALOR NOMBRE DEL CONTRATO ES OBLIGATORIO');
			else
				strNombreContrato = atributo.strValor;
		}
		if(atributo.strApi == 'Status')
		{
			if(atributo.strValor == '' || atributo.strValor == null)
				return new TER_Servicios_ws.TER_Response('FAIL','2','EL VALOR ESTADO DEL CONTRATO ES OBLIGATORIO');
			else
				strEstadoContrato = atributo.strValor;
		}
		if(atributo.strApi == 'Ter_Titulo__c')
		{
			if(atributo.strValor == '' || atributo.strValor == null)
				return new TER_Servicios_ws.TER_Response('FAIL','2','EL VALOR TÍTULO DEL CONTRATO ES OBLIGATORIO');
			else
				strTituloContrato = atributo.strValor;
		}
		if(atributo.strApi == 'Ter_Valor_del_Contrato__c')
		{
			if(atributo.strValor == '' || atributo.strValor == null)
				return new TER_Servicios_ws.TER_Response('FAIL','2','EL VALOR DEL CONTRATO ES OBLIGATORIO');
			else
				strValorContrato = atributo.strApi;
		}
		if(atributo.strApi == 'StartDate')
		{
			if(atributo.strValor == '' || atributo.strValor == null)
				return new TER_Servicios_ws.TER_Response('FAIL','2','EL VALOR DE LA FECHA DE INICIO DEL CONTRATO ES OBLIGATORIO');
			else
				strFechaIniContrato = atributo.strValor;
		}
		if(atributo.strApi == 'Ter_Fecha_de_Fin__c')
		{
			if(atributo.strValor == '' || atributo.strValor == null)
				return new TER_Servicios_ws.TER_Response('FAIL','2','EL VALOR DE LA FECHA DE FINALIZACIÓN DEL CONTRATO ES OBLIGATORIO');
			else
				strFechaFinContrato = atributo.strValor;
		}
		if(atributo.strApi == 'Ter_Link_para_Detalle__c')
		{
			if(atributo.strValor == '' || atributo.strValor == null)
				return new TER_Servicios_ws.TER_Response('FAIL','2','EL VALOR DEL LINK DEL CONTRATO ES OBLIGATORIO');
			else
				strLinkContrato = atributo.strValor;
		}
		
		return null;
	}*/
}