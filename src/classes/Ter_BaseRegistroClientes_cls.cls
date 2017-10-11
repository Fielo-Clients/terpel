/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase Base que extienden los controladores de las paginas de Actualizar/Registrar Clientes
					datos usando el algoritmo AES256 CBC
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    17/05/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public without sharing virtual class Ter_BaseRegistroClientes_cls {
	
	protected Map<string, Configuracion_General__c> mapConfiguracionGeneral;
	
	protected Ter_DatosClienteDTO_cls objDatosClienteDTO;
	
	protected Account objCuenta;
	
	protected boolean blnCuentaExiste;
	
	protected Date dtFechaNacimiento;
	
	protected list<RecordType> lstRecordTypeClienteLifeMiles;
	
	protected list<FieloPLT__Program__c> lstProgram;
	
	public boolean blnError {get; set;}
	
	public String strErrores;
	
	public String strHTMLError {get; set;}
	
	public String strUrlRedirect {get; set;}
	
	public String strHTML {get; set;}
	
	public String strDatos {get; set;}
	
	protected final String COMODIN_CAMPOS = '<<campo>>';
	
	/* 
	* Nombre: Ter_BaseRegistroClientes_cls
    * Descripcion: Constructor base usado en las paginas de integracion para el Registro/Actualizacion
    *			   de la informacion de los clientes de Club Terpel
    * Fecha Creación: 17/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            17-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public Ter_BaseRegistroClientes_cls(){
		Ter_UtilEncriptacion_cls objUtilEncriptacion;
		Integer intEdad;
		list<Account> lstCuenta;
		map<String, String> mapCodigosError;
		map<string, Ter_Homologacion_Listas__c> mapDatosHomologados;
		System.debug('Registro clientes');
		objDatosClienteDTO = new Ter_DatosClienteDTO_cls();
		blnError = false;
		strErrores = '';
		
		this.mapConfiguracionGeneral = Configuracion_General__c.getAll();
		
		//Se obtienen los parametros que llegan a la pagina
		objDatosClienteDTO.setStrNumeroLifeMiles(ApexPages.currentPage().getParameters().get('FFN'));
		objDatosClienteDTO.setStrFirstName(ApexPages.currentPage().getParameters().get('FNAME'));
		objDatosClienteDTO.setStrSegundoNombre(ApexPages.currentPage().getParameters().get('SNAME'));
		objDatosClienteDTO.setStrLastName(ApexPages.currentPage().getParameters().get('PLNAME'));
		objDatosClienteDTO.setStrSegundoApellido(ApexPages.currentPage().getParameters().get('SLNAME'));
		objDatosClienteDTO.setStrPersonBirthdate(ApexPages.currentPage().getParameters().get('BIRDT'));
		objDatosClienteDTO.setStrPersonEmail(ApexPages.currentPage().getParameters().get('EMAIL'));
		objDatosClienteDTO.setStrPersonHomePhone(ApexPages.currentPage().getParameters().get('PHONE'));
		objDatosClienteDTO.setStrGenero(ApexPages.currentPage().getParameters().get('GEND'));
		objDatosClienteDTO.setStrPersonMailingPostalCode(ApexPages.currentPage().getParameters().get('POSTCOD'));
		objDatosClienteDTO.setStrTipoDocumento(ApexPages.currentPage().getParameters().get('TDOC'));
		objDatosClienteDTO.setStrPaisDocumento(ApexPages.currentPage().getParameters().get('CTRDOC'));
		objDatosClienteDTO.setStrNumeroIdentificacion(ApexPages.currentPage().getParameters().get('NDOC'));
		objDatosClienteDTO.setStrLanguage(ApexPages.currentPage().getParameters().get('LANG'));
		objDatosClienteDTO.setStrPersonMailingStreet(ApexPages.currentPage().getParameters().get('ADDRC'));
		objDatosClienteDTO.setStrPersonMailingCountry(ApexPages.currentPage().getParameters().get('CTRC'));
		objDatosClienteDTO.setStrPersonMailingState(ApexPages.currentPage().getParameters().get('STC'));
		objDatosClienteDTO.setStrPersonMailingCity(ApexPages.currentPage().getParameters().get('CITYC'));
		objDatosClienteDTO.setStrClubTerpelAgreementAccepted(ApexPages.currentPage().getParameters().get('TCPTP'));
		objDatosClienteDTO.setStrClubTerpelAgreementDate(ApexPages.currentPage().getParameters().get('DTYCTP'));
		objDatosClienteDTO.setStrSessionId(ApexPages.currentPage().getParameters().get('SESSION'));
		objDatosClienteDTO.setStrBalanceLifeMiles(ApexPages.currentPage().getParameters().get('BLN'));
		objDatosClienteDTO.setStrErrorCode(ApexPages.currentPage().getParameters().get('CDERROR'));
		objDatosClienteDTO.setStrSolicitudTarjetaLM(ApexPages.currentPage().getParameters().get('STCD'));
		
		
		system.debug('====>>> Llego StrErrorCode: ' + objDatosClienteDTO.getStrErrorCode());
		system.debug('====>>> Ter_lbl_Codigo_Cliente_Duplicado_LM: ' + label.Ter_lbl_Codigo_Cliente_Duplicado_LM);
		system.debug('====>>> Ter_lbl_Codigo_Exito_Cliente_LM: ' + label.Ter_lbl_Codigo_Exito_Cliente_LM);
		//Se valida si la informacion que llega de LifeMiles viene con codigo de error diferente al de exito
		if(!String.isEmpty(objDatosClienteDTO.getStrErrorCode())){
			if(objDatosClienteDTO.getStrErrorCode().equals(label.Ter_lbl_Codigo_Cliente_Duplicado_LM)){
				system.debug('************* SE VINO POR CLIENTE DUPLICADO *****************');
				strHTMLError = paginaError(label.Ter_lbl_Mensaje_Cliente_Duplicado_LM + ' Error code: ' + objDatosClienteDTO.getStrErrorCode());
				return;
			}else if(!objDatosClienteDTO.getStrErrorCode().equals(label.Ter_lbl_Codigo_Exito_Cliente_LM)){
				system.debug('************* SE VINO POR ERROR CODIGO EXITO *****************');
				mapCodigosError =  Ter_Utilidades_cls.obtenerCodigosError(label.Ter_lbl_Proceso_Registro_Clientes);
				system.debug('====>>> mapCodigosError: ' + mapCodigosError);
				if(mapCodigosError.containsKey(objDatosClienteDTO.getStrErrorCode())){
					system.debug('************* SE VINO POR ERROR MAPEADO *****************');
					strHTMLError = paginaError(mapCodigosError.get(objDatosClienteDTO.getStrErrorCode()) + ' Error code: ' + objDatosClienteDTO.getStrErrorCode() );
					return;
				} else{
					system.debug('************* SE VINO POR ERROR GENERICO *****************');
					strHTMLError = paginaError(label.Ter_lbl_Error_Generico_Registro_Clientes+ ' Error code: ' + objDatosClienteDTO.getStrErrorCode() );
					return;
				}
			}
		}
		
		system.debug('************* NO LLEGO CODIGO FALLIDO, LLEGO EXITOSO *****************');
		
		//Validar campos obligatorios
		validarCamposObligatorios();
		
		if(blnError){
			strHTMLError = paginaError(strErrores);
			return;
		}
		
		this.lstProgram = [SELECT OwnerId FROM FieloPLT__Program__c WHERE Name = :label.Ter_lbl_Nombre_Programa_Club_Terpel];
		
		if(this.lstProgram.isEmpty()){
			strHTMLError = paginaError('El programa ' + label.Ter_lbl_Nombre_Programa_Club_Terpel + ' no ha sido configurado en el sistema.');
			return;
		}
		
		objUtilEncriptacion = new Ter_UtilEncriptacion_cls();
		blnCuentaExiste = false;
		
		//Se validan los datos que no lleguen nulos para que sean desencriptados
		try{
			if(!String.isEmpty(objDatosClienteDTO.getStrNumeroLifeMiles())){
				objDatosClienteDTO.setStrNumeroLifeMiles(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrNumeroLifeMiles()));
			} 
			
			if(!String.isEmpty(objDatosClienteDTO.getStrFirstName())){
				objDatosClienteDTO.setStrFirstName(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrFirstName()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrSegundoNombre())){
				objDatosClienteDTO.setStrSegundoNombre(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrSegundoNombre()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrLastName())){
				objDatosClienteDTO.setStrLastName(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrLastName()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrSegundoApellido())){
				objDatosClienteDTO.setStrSegundoApellido(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrSegundoApellido()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrPersonBirthdate())){
				objDatosClienteDTO.setStrPersonBirthdate(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrPersonBirthdate()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrPersonEmail())){
				objDatosClienteDTO.setStrPersonEmail(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrPersonEmail()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrPersonHomePhone())){
				objDatosClienteDTO.setStrPersonHomePhone(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrPersonHomePhone()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrGenero())){
				objDatosClienteDTO.setStrGenero(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrGenero()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrPersonMailingPostalCode())){
				objDatosClienteDTO.setStrPersonMailingPostalCode(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrPersonMailingPostalCode()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrTipoDocumento())){
				objDatosClienteDTO.setStrTipoDocumento(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrTipoDocumento()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrPaisDocumento())){
				objDatosClienteDTO.setStrPaisDocumento(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrPaisDocumento()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrNumeroIdentificacion())){
				objDatosClienteDTO.setStrNumeroIdentificacion(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrNumeroIdentificacion()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrLanguage())){
				objDatosClienteDTO.setStrLanguage(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrLanguage()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrPersonMailingStreet())){
				objDatosClienteDTO.setStrPersonMailingStreet(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrPersonMailingStreet()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrPersonMailingCountry())){
				objDatosClienteDTO.setStrPersonMailingCountry(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrPersonMailingCountry()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrPersonMailingState())){
				objDatosClienteDTO.setStrPersonMailingState(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrPersonMailingState()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrPersonMailingCity())){
				objDatosClienteDTO.setStrPersonMailingCity(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrPersonMailingCity()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrClubTerpelAgreementAccepted())){
				objDatosClienteDTO.setStrClubTerpelAgreementAccepted(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrClubTerpelAgreementAccepted()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrClubTerpelAgreementDate())){
				objDatosClienteDTO.setStrClubTerpelAgreementDate(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrClubTerpelAgreementDate()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrSessionId())){
				objDatosClienteDTO.setStrSessionId(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrSessionId()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrBalanceLifeMiles())){
				objDatosClienteDTO.setStrBalanceLifeMiles(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrBalanceLifeMiles()));
			}
			
			if(!String.isEmpty(objDatosClienteDTO.getStrSolicitudTarjetaLM())){
				objDatosClienteDTO.setStrSolicitudTarjetaLM(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrSolicitudTarjetaLM()));
			}
			
			/*if(!String.isEmpty(objDatosClienteDTO.getStrErrorCode())){
				objDatosClienteDTO.setStrErrorCode(objUtilEncriptacion.desencriptarAES256_Registro(objDatosClienteDTO.getStrErrorCode()));
			}*/
		} catch(Exception e){
			strHTMLError = paginaError(label.Ter_lbl_Error_Desencriptando);
			return;
		}
		
		//paginaError('....................');
		system.debug('**********************************************************************');
		system.debug(objDatosClienteToString());
		system.debug('**********************************************************************');
		
		if(objDatosClienteDTO.getStrTipoDocumento() == null || objDatosClienteDTO.getStrNumeroIdentificacion() == null){
			strHTMLError = paginaError(label.Ter_lbl_Error_Autenticacion_NroDocumento); 
			return;
		}
		
		//Valida que la persona que esta llegando no sea menor de 18 años
		//si es menor se debe mostrar mensaje de error
		if(!String.isEmpty(objDatosClienteDTO.getStrPersonBirthdate())){
			dtFechaNacimiento = Ter_Utilidades_cls.stringToDateLM(objDatosClienteDTO.getStrPersonBirthdate());
			objDatosClienteDTO.setDtFechaNacimiento(dtFechaNacimiento);
			intEdad = Ter_Utilidades_cls.calcularEdad(dtFechaNacimiento);
			
			if(mapConfiguracionGeneral.containsKey(label.Ter_lbl_CP_General) && mapConfiguracionGeneral.get(label.Ter_lbl_CP_General).Ter_Limite_Edad_Clientes__c != null){
				if(intEdad < mapConfiguracionGeneral.get(label.Ter_lbl_CP_General).Ter_Limite_Edad_Clientes__c){
					strHTMLError = paginaError(label.Ter_lbl_Msj_Error_Edad);
					return;
				}
			}
		}
		
		if(!String.isEmpty(objDatosClienteDTO.getStrClubTerpelAgreementAccepted())){
			if(objDatosClienteDTO.getStrClubTerpelAgreementAccepted().equals(label.Ter_lbl_ClubTerpel_Agreement_Accepted)){
				objDatosClienteDTO.setBlnClubTerpelAgreementAccepted(true);
			} else{
				objDatosClienteDTO.setBlnClubTerpelAgreementAccepted(false);
			}
		}
		
		if(!String.isEmpty(objDatosClienteDTO.getStrClubTerpelAgreementDate())){
			objDatosClienteDTO.setDtClubTerpelAgreementDate(Ter_Utilidades_cls.stringToDateLM(objDatosClienteDTO.getStrClubTerpelAgreementDate()));
		}
		
		//Se homologa el tipo de documento
		mapDatosHomologados = Ter_Utilidades_cls.obtenerDatosHomologados(new set<String> { 'Account' });
		
		if(!String.isEmpty(objDatosClienteDTO.getStrTipoDocumento()) && !mapDatosHomologados.containsKey('Account'+'Ter_Tipo_documento__c'+objDatosClienteDTO.getStrTipoDocumento())){
			strHTMLError = paginaError('Tipo de documento no se pudo homologar');
			return;
		} else{
			objDatosClienteDTO.setStrTipoDocumento(mapDatosHomologados.get('Account'+'Ter_Tipo_documento__c'+objDatosClienteDTO.getStrTipoDocumento()).Ter_Valor_Homologado__c); 
		}
		system.debug('************* SE HOMOLOGO EL TIPO DE DOCUMENTO *****************');
		/*
		if(!String.isEmpty(objDatosClienteDTO.getStrPaisDocumento()) && !mapDatosHomologados.containsKey('Account'+'Ter_Pais_documento__c'+objDatosClienteDTO.getStrPaisDocumento())){
			strHTMLError = paginaError('País Documento no se pudo homologar');
			return;
		} else{
			objDatosClienteDTO.setStrPaisDocumento(mapDatosHomologados.get('Account'+'Ter_Pais_documento__c'+objDatosClienteDTO.getStrPaisDocumento()).Ter_Valor_Homologado__c); 
		}
		
		if(!String.isEmpty(objDatosClienteDTO.getStrPersonMailingCountry()) && !mapDatosHomologados.containsKey('Account'+'Ter_Pais_documento__c'+objDatosClienteDTO.getStrPersonMailingCountry())){
			strHTMLError = paginaError('País de residencia no se pudo homologar');
			return;
		} else{
			objDatosClienteDTO.setStrPersonMailingCountry(mapDatosHomologados.get('Account'+'Ter_Pais_documento__c'+objDatosClienteDTO.getStrPersonMailingCountry()).Ter_Valor_Homologado__c); 
		}
		
		if(!String.isEmpty(objDatosClienteDTO.getStrPersonMailingState()) && !mapDatosHomologados.containsKey('Account'+'PersonMailingState'+objDatosClienteDTO.getStrPersonMailingState())){
			strHTMLError = paginaError('Departamento no se pudo homologar.');
			return;
		} else{
			objDatosClienteDTO.setStrPersonMailingState(mapDatosHomologados.get('Account'+'PersonMailingState'+objDatosClienteDTO.getStrPersonMailingState()).Ter_Valor_Homologado__c); 
		}*/
		
		//Se consulta el registro del Account
		lstCuenta = new list<Account>();
		lstCuenta = [SELECT Id, F_NumeroLifeMiles__c, FirstName, MiddleName, LastName, Suffix,
							Ter_Fecha_de_nacimiento__pc, PersonEmail, PersonMobilePhone, Ter_Genero__pc, BillingPostalCode, 
							Ter_Tipo_documento__pc, Ter_Pais_documento__pc, Ter_Numero_de_identificacion__c, PersonMailingStreet, 
							PersonMailingCountry, PersonMailingState, PersonMailingCity, F_ClubTerpelAgreementAccepted__c, 
							F_ClubTerpelAgreementDate__c, F_SessionId__c, F_BalanceLifeMiles__c, BillingStreet, BillingCity, BillingState, 
							BillingCountry, F_Member__c 
					 FROM Account 
					 WHERE F_NumeroLifeMiles__c = :objDatosClienteDTO.getStrNumeroLifeMiles() AND isPersonAccount = true];
		
		if(lstCuenta.isEmpty() && !String.isEmpty(objDatosClienteDTO.getStrNumeroIdentificacion())){
			lstCuenta = [SELECT Id, F_NumeroLifeMiles__c, FirstName, MiddleName, LastName, Suffix,
								Ter_Fecha_de_nacimiento__pc, PersonEmail, PersonMobilePhone, Ter_Genero__pc, BillingPostalCode, 
								Ter_Tipo_documento__pc, Ter_Pais_documento__pc, Ter_Numero_de_identificacion__c, PersonMailingStreet, 
								PersonMailingCountry, PersonMailingState, PersonMailingCity, F_ClubTerpelAgreementAccepted__c, 
								F_ClubTerpelAgreementDate__c, F_SessionId__c, F_BalanceLifeMiles__c, BillingStreet, BillingCity, BillingState, 
								BillingCountry, F_Member__c 
						 FROM Account 
						 WHERE Ter_Numero_de_identificacion__c = :objDatosClienteDTO.getStrNumeroIdentificacion() AND isPersonAccount = true];
			
			if(lstCuenta.isEmpty()){
				//la Cuenta se debe crear
				blnCuentaExiste = false;
				objCuenta = new Account(); 
			} else{
				if(lstCuenta.get(0).F_NumeroLifeMiles__c != null && lstCuenta.get(0).F_NumeroLifeMiles__c != objDatosClienteDTO.getStrNumeroLifeMiles()){
					strHTMLError = paginaError(label.Ter_lbl_Cliente_Duplicado);
					return;
				}
				//La Cuenta se debe actualizar
				objCuenta = lstCuenta.get(0);
				blnCuentaExiste = true;
			}
		} else{
			//La Cuenta se debe actualizar
			objCuenta = lstCuenta.get(0);
			blnCuentaExiste = true;
		}
		system.debug('************* SE CONSULTO LA CUENTA, EXISTE = '+blnCuentaExiste+' *****************');
		system.debug('=====>>>>> ' + objCuenta);
		
	}
	
	/* 
	* Nombre: validarCamposObligatorios
    * Descripcion: Metodo Virtual el cual debe ser sobre-escrito en cada clase que herede (extienda) 
    *			   esta clase base, la idea es que cuando este metodo se sobre-escribe contenga la 
    * 			   logica especifica para validar campos obligatorios.
    * Fecha Creación: 01/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            1-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public virtual void validarCamposObligatorios(){
		system.debug('=====>>>>> Metodo Virtual [validarCamposObligatorios]');
	}
	
	/* 
	* Nombre: login
    * Descripcion: Metodo encargado de logear el usuario asociado al cliente que 
    * 			   llegó en el proceso de Registro/Autenticacion/Actualizacion/Guest
    * Fecha Creación: 25/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            25-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	protected void login(){
		String strStartURL;
		blnError = false;
		FieloPLT__Member__c objMember;
		map<String, Fielo_RedirectURLs_ClubTerpel__c> mapFieloURLs;
		list<FieloPLT__Member__c> lstMember;
		list<Account> lstCuentaAux;
		
		system.debug('************* ENTRO EN METODO LOGIN *****************');
		
		lstCuentaAux = [SELECT Id, F_Member__c FROM Account WHERE Id = :objCuenta.Id];
		/*if(lstCuentaAux == null || lstCuentaAux.isEmpty()){
			strHTMLError = paginaError('No se pudo consultar la cuenta para obtener el Member asociado');
			return;
		}*/
		
		lstMember = [SELECT Id, F_FirstLogin__c, FieloPLT__User__c, FieloPLT__User__r.IsActive FROM FieloPLT__Member__c WHERE Id = :lstCuentaAux.get(0).F_Member__c];
		
		/*if(lstMember == null || lstMember.isEmpty()){
			strHTMLError = paginaError('No se pudo identificar el Member para el primer login');
			return;
		} */
		
		if(!lstMember.get(0).FieloPLT__User__r.IsActive){
			system.debug('======> USUARIO INACTIVO');
			strHTMLError = paginaError(label.Ter_lbl_UsuarioFielo_Inactivo);
			return;
		}
		
		mapFieloURLs = Fielo_RedirectURLs_ClubTerpel__c.getAll();
		
		if(lstRecordTypeClienteLifeMiles.get(0).DeveloperName.equals(label.Ter_lbl_RT_ClienteTerpel)){
			if(lstMember.get(0).F_FirstLogin__c == true){
				//strStartURL = label.Fielo_URLPrimerLoginClienteTerpel;
				strStartURL = mapFieloURLs.get('Fielo_URLPrimerLoginClienteTerpel').F_URL__c;
				//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, '---> Fielo_URLPrimerLoginClienteTerpel: ' + strStartURL));
			} else{
				//strStartURL = label.Fielo_URLHomeClienteTerpel;
				strStartURL = mapFieloURLs.get('Fielo_URLHomeClienteTerpel').F_URL__c;
				//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, '---> Fielo_URLHomeClienteTerpel: ' + strStartURL));
			}
		}else if(lstRecordTypeClienteLifeMiles.get(0).DeveloperName.equals(label.Ter_lbl_RT_ClienteLifeMiles)){
			//strStartURL = label.Fielo_URLHomeClienteLifeMiles;
			strStartURL = mapFieloURLs.get('Fielo_URLHomeClienteLifeMiles').F_URL__c;
			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, '---> Fielo_URLHomeClienteLifeMiles: ' + strStartURL));
		} else{
			//Error RecordType desconocido
			blnError = true;
		}
		system.debug('************* strStartURL: '+strStartURL+' *****************');
		
		if(!blnError){
			system.debug('************* \nUSR: '+objCuenta.F_NumeroLifeMiles__c + label.Ter_lbl_Sufijo_Usuario_Fielo+' \nPWD: '+objCuenta.F_SessionId__c+'\n *****************');
			PageReference pagLogin = Site.login(objCuenta.F_NumeroLifeMiles__c + label.Ter_lbl_Sufijo_Usuario_Fielo, objCuenta.F_SessionId__c, strStartURL);
			if(pagLogin != null){
				strUrlRedirect = pagLogin.getUrl();
				system.debug('************* HIZO LOGIN, VA A REDIRIGIR A: '+strUrlRedirect+' *****************');
				//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, '---> pagLogin: ' + pagLogin.getUrl()));
			} else{
				system.debug('************* LOGIN NULO *****************');
				strHTMLError = paginaError('No se pudo redireccionar al sitio de Club Terpel [1]');
				return;
			}
		} else{
			system.debug('************* HUBO ERROR Y NO VA A INTETAR HACER LOGIN *****************');
			strHTMLError = paginaError('No se pudo redireccionar al sitio de Club Terpel [2]');
			return;
		}
	}
	
	/* 
	* Nombre: paramToString
    * Descripcion: Metodo que retorna un String con todos los parametros para verlos en la página
    * Fecha Creación: 17/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            17-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public String paramToString(){
		return 'strNumeroLifeMiles: ' + objDatosClienteDTO.getStrNumeroLifeMiles() + '<br>'
				+ 'strFirstName: ' + objDatosClienteDTO.getStrFirstName() + '<br>'
				+ 'strSegundoNombre: ' + objDatosClienteDTO.getStrSegundoNombre() + '<br>'
				+ 'strLastName: ' + objDatosClienteDTO.getStrLastName() + '<br>'
				+ 'strSegundoApellido: ' + objDatosClienteDTO.getStrSegundoApellido() + '<br>'
				+ 'strPersonBirthdate: ' + objDatosClienteDTO.getStrPersonBirthdate() + '<br>'
				+ 'strPersonEmail: ' + objDatosClienteDTO.getStrPersonEmail() + '<br>'
				+ 'strPersonHomePhone: ' + objDatosClienteDTO.getStrPersonHomePhone() + '<br>'
				+ 'strGenero: ' + objDatosClienteDTO.getStrGenero() + '<br>'
				+ 'strPersonMailingPostalCode: ' + objDatosClienteDTO.getStrPersonMailingPostalCode() + '<br>'
				+ 'strTipoDocumento: ' + objDatosClienteDTO.getStrTipoDocumento() + '<br>'
				+ 'strPaisDocumento: ' + objDatosClienteDTO.getStrPaisDocumento() + '<br>'
				+ 'strNumeroIdentificacion: ' + objDatosClienteDTO.getStrNumeroIdentificacion() + '<br>'
				+ 'strLanguage: ' + objDatosClienteDTO.getStrLanguage() + '<br>'
				+ 'strPersonMailingStreet: ' + objDatosClienteDTO.getStrPersonMailingStreet() + '<br>'
				+ 'strPersonMailingCountry: ' + objDatosClienteDTO.getStrPersonMailingCountry() + '<br>'
				+ 'strPersonMailingState: ' + objDatosClienteDTO.getStrPersonMailingState() + '<br>'
				+ 'strPersonMailingCity: ' + objDatosClienteDTO.getStrPersonMailingCity() + '<br>'
				+ 'strClubTerpelAgreementAccepted: ' + objDatosClienteDTO.getStrClubTerpelAgreementAccepted() + '<br>'
				+ 'strClubTerpelAgreementDate: ' + objDatosClienteDTO.getStrClubTerpelAgreementDate() + '<br>'
				+ 'strSessionId: ' + objDatosClienteDTO.getStrSessionId() + '<br>'
				+ 'strBalanceLifeMiles: ' + objDatosClienteDTO.getStrBalanceLifeMiles() + '<br>'
				+ 'strErrorCode: ' + objDatosClienteDTO.getStrErrorCode();
		
	}
	
	public String objDatosClienteToString(){
		return '\n\nstrNumeroLifeMiles: ' + objDatosClienteDTO.getStrNumeroLifeMiles() + '\n'
				+ 'strFirstName: ' + objDatosClienteDTO.getStrFirstName() + '\n'
				+ 'strSegundoNombre: ' + objDatosClienteDTO.getStrSegundoNombre() + '\n'
				+ 'strLastName: ' + objDatosClienteDTO.getStrLastName() + '\n'
				+ 'strSegundoApellido: ' + objDatosClienteDTO.getStrSegundoApellido() + '\n'
				+ 'strPersonBirthdate: ' + objDatosClienteDTO.getStrPersonBirthdate() + '\n'
				+ 'strPersonEmail: ' + objDatosClienteDTO.getStrPersonEmail() + '\n'
				+ 'strPersonHomePhone: ' + objDatosClienteDTO.getStrPersonHomePhone() + '\n'
				+ 'strGenero: ' + objDatosClienteDTO.getStrGenero() + '\n'
				+ 'strPersonMailingPostalCode: ' + objDatosClienteDTO.getStrPersonMailingPostalCode() + '\n'
				+ 'strTipoDocumento: ' + objDatosClienteDTO.getStrTipoDocumento() + '\n'
				+ 'strPaisDocumento: ' + objDatosClienteDTO.getStrPaisDocumento() + '\n'
				+ 'strNumeroIdentificacion: ' + objDatosClienteDTO.getStrNumeroIdentificacion() + '\n'
				+ 'strLanguage: ' + objDatosClienteDTO.getStrLanguage() + '\n'
				+ 'strPersonMailingStreet: ' + objDatosClienteDTO.getStrPersonMailingStreet() + '\n'
				+ 'strPersonMailingCountry: ' + objDatosClienteDTO.getStrPersonMailingCountry() + '\n'
				+ 'strPersonMailingState: ' + objDatosClienteDTO.getStrPersonMailingState() + '\n'
				+ 'strPersonMailingCity: ' + objDatosClienteDTO.getStrPersonMailingCity() + '\n'
				+ 'strClubTerpelAgreementAccepted: ' + objDatosClienteDTO.getStrClubTerpelAgreementAccepted() + '\n'
				+ 'strClubTerpelAgreementDate: ' + objDatosClienteDTO.getStrClubTerpelAgreementDate() + '\n'
				+ 'strSessionId: ' + objDatosClienteDTO.getStrSessionId() + '\n'
				+ 'strBalanceLifeMiles: ' + objDatosClienteDTO.getStrBalanceLifeMiles() + '\n'
				+ 'strErrorCode: ' + objDatosClienteDTO.getStrErrorCode() + '\n\n';
		
	}
	
	/* 
	* Nombre: paginaError
    * Descripcion: Metodo que retorna un String un HTML para mostrar los mensajes de error
    * Fecha Creación: 17/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            17-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	protected String paginaError(String strMensajeError){
		blnError = true;
        return '<style type="text/css">'
				+'<!--'
				+'body{margin:0;font-size:.7em;font-family:Verdana, Arial, Helvetica, sans-serif;background:#EEEEEE;}'
				+'fieldset{padding:0 15px 10px 15px;} '
				+'h2{font-size:1.7em;margin:0;color:#CC0000;} '
				+'h3{font-size:1.2em;margin:10px 0 0 0;color:#000000;} '
				+'background-color:#555555;}'
				+'#content{margin:0 0 0 2%;position:relative;}'
				+'.content-container{background:#FFF;width:96%;margin-top:8px;padding:10px;position:relative;}'
				+'-->'
				+'</style>'
				+'<div id="content">'
				+' <div class="content-container"><fieldset>'
				+'  <h2>Error</h2><br>'
				+'  <h3>' + strMensajeError + '</h3>'
				+' </fieldset></div>'
				+'</div>';
    }
    
    /* 
	* Nombre: htmlConstruccion
    * Descripcion: Metodo que retorna un String el HTML que indica que la pagina esta en construccion
    * Fecha Creación: 17/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            17-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    protected String htmlConstruccion(){
		return '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"'
				+ '"http://www.w3.org/TR/html4/loose.dtd">'
				+ '<html>'
				+ '	<head>'
				+ '		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
				+ '		<title>Avanxo/Fielo/Terpel</title>'
				+ '	</head>'
				+ '	<body>'
				+ '		<br><br><br><br><br><br><br>'
				+ '		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">'
				+ '			<tr>'
				+ '				<td align="center">'
				+ '					<h1 style="margin:0;padding:0;font-family: trebuchet ms;font-size: 250%;">Este sitio esta en construcción.</h1>'
				+ '					<br>'
				+ '					<h2 style="margin:0;padding:0;font-family: trebuchet ms;color: #888;font-size: 200%;">Regrese pronto.</h2>'
				+ '				</td>'
				+ '			</tr>'
				+ '		</table>'
				+ '	</body>'
				+ '</html>';
	}
	

}