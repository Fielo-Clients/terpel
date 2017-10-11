/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Controlador para la integracion con la pagina encargada de Registrar/Actualizar los usuario 
* 					invitados que vienen de LifeMiles la momento de ser redireccionados al portal de Club Terpel
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    17/05/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public without sharing class Ter_LifemilesGuest_ctr{
	
	private list<RecordType> lstRecordTypeClienteLifeMiles;
	private Ter_DatosClienteDTO_cls objDatosClienteDTO;
	private Account objCuenta;
	private String strToken;
	private String strMemberId;
	private boolean blnCuentaExiste;
	private list<FieloPLT__Program__c> lstProgram;
	public boolean blnError {get; set;}
	public String strErrores;
	public String strHTMLError {get; set;}
	public String strUrlRedirect {get; set;}
	public String strHTML {get; set;}
	public String strDatos {get; set;}
	private final String COMODIN_CAMPOS = '<<campo>>';
	
	/* 
	* Nombre: Ter_TerpelAutentication_ctr
    * Descripcion: Constructor para crear un cliente invitado con informacion basica
    * Fecha Creación: 17/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            17-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public Ter_LifemilesGuest_ctr(){
		Ter_SecurityTokenValidationResponse objSecurityTokenValidationResponse;
		Ter_MemberValidationResponse objMemberValidationResponse;
		Ter_LifeMilesConversionWsConsumer_cls objConsumer;
		list<Account> lstCuenta;
		String strIdioma;
		
		blnError = false;
		
		
		strMemberId = ApexPages.currentPage().getParameters().get('ffn');
		strToken = ApexPages.currentPage().getParameters().get('tkn');
		strIdioma = ApexPages.currentPage().getParameters().get('lng');
		
		//Validar campos obligatorios
		validarCamposObligatorios();
		
		if(blnError){
			strHTMLError = paginaError(strErrores);
			return;
		}
		
		lstProgram = [SELECT OwnerId FROM FieloPLT__Program__c WHERE Name = :label.Ter_lbl_Nombre_Programa_Club_Terpel];
		
		if(this.lstProgram.isEmpty()){
			strHTMLError = paginaError('El programa ' + label.Ter_lbl_Nombre_Programa_Club_Terpel + ' no ha sido configurado en el sistema.');
			return;
		}
		
		objConsumer = new Ter_LifeMilesConversionWsConsumer_cls();
		objSecurityTokenValidationResponse = objConsumer.invokeValidateSecurityTokenStr(strToken, strMemberId);
		
		if(!objSecurityTokenValidationResponse.Body.SecurityTokenValidationResponse.response_code.equals('000')){
			strHTMLError = paginaError('No se pudo obtener la sesión, porfavor intente nuevamente mas tarde.');
			return;
		}
		
		objMemberValidationResponse = objConsumer.invokeValidateMemberStr(objSecurityTokenValidationResponse.Body.SecurityTokenValidationResponse.session, strMemberId);
		
		if(!objMemberValidationResponse.Body.MemberValidationResponse.response_code.equals('000')){
			strHTMLError = paginaError('No se pudo obtener la informacio de LifeMiles, porfavor intente nuevamente mas tarde.');
			return;
		}
		
		objDatosClienteDTO = new Ter_DatosClienteDTO_cls();
		objDatosClienteDTO.setStrNumeroLifeMiles(objMemberValidationResponse.Body.MemberValidationResponse.member_id);
		objDatosClienteDTO.setStrFirstName(objMemberValidationResponse.Body.MemberValidationResponse.first_name);
		//objDatosClienteDTO.setStrSegundoNombre(xxxx);
		objDatosClienteDTO.setStrLastName(objMemberValidationResponse.Body.MemberValidationResponse.last_name);
		//objDatosClienteDTO.setStrSegundoApellido(xxxx);
		objDatosClienteDTO.setStrPersonEmail(objMemberValidationResponse.Body.MemberValidationResponse.email);
		objDatosClienteDTO.setStrSessionId(objSecurityTokenValidationResponse.Body.SecurityTokenValidationResponse.session);
		objDatosClienteDTO.setStrBalanceLifeMiles(objMemberValidationResponse.Body.MemberValidationResponse.account_balance);
		
		
		lstRecordTypeClienteLifeMiles = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = :label.Ter_lbl_RT_ClienteLifeMiles];
		
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
		
		if(lstCuenta.isEmpty()){
			//la Cuenta se debe crear
			blnCuentaExiste = false;
			objCuenta = new Account();
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
    * Descripcion: Metodo sobre-escrito el cual contiene la logica especifica para validar los 
    * 			   campos obligatorios de acuerdo a la pagina que se este llamando
    * Fecha Creación: 01/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            1-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public void validarCamposObligatorios(){
		system.debug('=====>>>>> [Ter_LifemilesGuest_ctr] Override validarCamposObligatorios'); 
		
		if(String.isBlank(strToken)){
			blnError = true;
			strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Token');
		}
		
		if(String.isBlank(strMemberId)){
			blnError = true;
			strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Número LifeMiles');
		}
		
	}
	
	/* 
	* Nombre: procesarRegistro
    * Descripcion: Metodo encargado de procesar el registro o la actualizacion de una cuenta que llego desdes LifeMiles
    * Fecha Creación: 05/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            5-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public void procesarRegistro(){
		if(!blnError){
			objCuenta.F_NumeroLifeMiles__c = objDatosClienteDTO.getStrNumeroLifeMiles();
			objCuenta.FirstName = objDatosClienteDTO.getStrFirstName();
			//objCuenta.MiddleName = objDatosClienteDTO.getStrSegundoNombre();
			objCuenta.LastName = objDatosClienteDTO.getStrLastName();
			//objCuenta.Suffix = objDatosClienteDTO.getStrSegundoApellido();
			objCuenta.PersonEmail = objDatosClienteDTO.getStrPersonEmail();
			//objCuenta.PersonMobilePhone = objDatosClienteDTO.getStrPersonHomePhone();
			objCuenta.F_SessionId__c = objDatosClienteDTO.getStrSessionId();
			objCuenta.F_Token__c = strToken;
			
			if(!blnCuentaExiste){
            	objCuenta.OwnerId = this.lstProgram.get(0).OwnerId;
            	objCuenta.F_CreateMember__c = true;
            	objCuenta.RecordTypeId = lstRecordTypeClienteLifeMiles.get(0).Id;
            }
			
			
			//FALTA DEFINIR ESTA PARTE SI HAY QUE CREARLE MEMBER O NO A LOS GUEST
			/*if(objDatosClienteDTO.isBlnClubTerpelAgreementAccepted()){
				if(!blnCuentaExiste){
					//Se pone el RecordType de tipo Cliente LifeMiles
					objCuenta.RecordTypeId = lstRecordTypeClienteLifeMiles.get(0).Id;
					//Se debe poner en true el campo para disparar el trigger de creacion de Member
					objCuenta.F_CreateMember__c = true;
					system.debug('=====>>>>> [Cuenta NO existe] Se seleccionó el campo F_CreateMember__c para que el Trigger de Fielo se Dispare.');
				} else if(!objCuenta.F_CreateMember__c){
					objCuenta.F_CreateMember__c = true;
					system.debug('=====>>>>> [Cuenta SI existe] Se seleccionó el campo F_CreateMember__c para que el Trigger de Fielo se Dispare.');
				}
			}*/
			
			system.debug('=====>>>>> Va a hacer Upsert sobre la cuenta. Cuenta Existe: ' + blnCuentaExiste);
			try{
                upsert objCuenta;
            } catch(Exception e){
                System.Debug('====================== EXCEPCION LifeMileGuest ======================');
                System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                System.Debug('=====================================================================');
                strHTMLError = paginaError(label.Ter_lbl_Error_Generico_Registro_Clientes );
                return;
            }
			
			login();
		} 
	}
	
	private void login(){
		String strStartURL;
		blnError = false;
		FieloPLT__Member__c objMember;
		map<String, Fielo_RedirectURLs_ClubTerpel__c> mapFieloURLs;
		list<FieloPLT__Member__c> lstMember;
		list<Account> lstCuentaAux;
		
		system.debug('************* ENTRO EN METODO LOGIN *****************');
		
		lstCuentaAux = [SELECT Id, F_Member__c FROM Account WHERE Id = :objCuenta.Id];
		
		lstMember = [SELECT Id, F_FirstLogin__c, FieloPLT__User__c, FieloPLT__User__r.IsActive FROM FieloPLT__Member__c WHERE Id = :lstCuentaAux.get(0).F_Member__c];
		
		if(!lstMember.get(0).FieloPLT__User__r.IsActive){
			system.debug('======> USUARIO INACTIVO');
			strHTMLError = paginaError(label.Ter_lbl_UsuarioFielo_Inactivo);
			return;
		}
		
		mapFieloURLs = Fielo_RedirectURLs_ClubTerpel__c.getAll();
		
		if(lstRecordTypeClienteLifeMiles.get(0).DeveloperName.equals(label.Ter_lbl_RT_ClienteTerpel)){
			if(lstMember.get(0).F_FirstLogin__c == true){
				strStartURL = mapFieloURLs.get('Fielo_URLPrimerLoginClienteTerpel').F_URL__c;
				//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, '---> Fielo_URLPrimerLoginClienteTerpel: ' + strStartURL));
			} else{
				strStartURL = mapFieloURLs.get('Fielo_URLHomeClienteTerpel').F_URL__c;
				//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, '---> Fielo_URLHomeClienteTerpel: ' + strStartURL));
			}
		}else if(lstRecordTypeClienteLifeMiles.get(0).DeveloperName.equals(label.Ter_lbl_RT_ClienteLifeMiles)){
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
	
	private String paginaError(String strMensajeError){
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
    
}