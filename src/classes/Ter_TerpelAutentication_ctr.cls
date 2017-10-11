/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Controlador para la integracion con la pagina encargada de Registrar/Actualizar los clientes 
*                   que vienen de LifeMiles la momento de registrarlos/iniciar sesion en ese sistema
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    17/05/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public without sharing class Ter_TerpelAutentication_ctr extends Ter_BaseRegistroClientes_cls{
    
    /* 
    * Nombre: Ter_TerpelAutentication_ctr
    * Descripcion: Constructor para Registrar/Actualizar clientes
    * Fecha Creación: 17/05/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            17-May-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    public Ter_TerpelAutentication_ctr(){
        super();
        lstRecordTypeClienteLifeMiles = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = :label.Ter_lbl_RT_ClienteTerpel];
        
        if(lstRecordTypeClienteLifeMiles.isEmpty()){
            strHTMLError = paginaError(label.Ter_lbl_Error_RT_ClienteLifeMiles);
            return;
        } 
        
        strDatos = paramToString();
        strHTML = htmlConstruccion(); 
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
    public override void validarCamposObligatorios(){
        system.debug('=====>>>>> [Ter_TerpelAutentication_ctr] Override validarCamposObligatorios'); 
        
        if(String.isEmpty(objDatosClienteDTO.getStrNumeroLifeMiles())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Número LifeMiles');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrFirstName())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Primer Nombre');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrSegundoNombre())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Segundo Nombre');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrLastName())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Primer Apellido');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrSegundoApellido())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Segundo Apellido');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrPersonBirthdate())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Fecha de Nacimiento');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrPersonEmail())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Correo Electrónico');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrPersonHomePhone())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Telefono');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrGenero())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Genero');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrPersonMailingPostalCode())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Código Postal');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrTipoDocumento())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Tipo Documento');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrPaisDocumento())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'País Documento');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrNumeroIdentificacion())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Número de Identificación');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrLanguage())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Lenguaje');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrPersonMailingStreet())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Dirección');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrPersonMailingCountry())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'País Residencia');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrPersonMailingState())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Departamento');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrPersonMailingCity())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Ciudad');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrClubTerpelAgreementAccepted())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Aceptar Terminos y Condiciones');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrClubTerpelAgreementDate())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Fecha Terminos y Condiciones');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrSessionId())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Session Id');
        }
        
        if(String.isEmpty(objDatosClienteDTO.getStrBalanceLifeMiles())){
            blnError = true;
            strErrores += label.Ter_lbl_Campo_Obligatorio.replace(COMODIN_CAMPOS, 'Balance de millas Acumuladas');
        }
        system.debug('===>>> ' + strErrores);
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
        	system.debug('************* VA A INICIALIZAR DATOS CUENTA CON LOS QUE LLEGARON *****************');
            objCuenta.F_NumeroLifeMiles__c = objDatosClienteDTO.getStrNumeroLifeMiles();
            objCuenta.FirstName = objDatosClienteDTO.getStrFirstName();
            objCuenta.MiddleName = objDatosClienteDTO.getStrSegundoNombre();
            objCuenta.LastName = objDatosClienteDTO.getStrLastName();
            objCuenta.Suffix = objDatosClienteDTO.getStrSegundoApellido();
            objCuenta.PersonBirthdate = objDatosClienteDTO.getDtFechaNacimiento();
            objCuenta.PersonEmail = objDatosClienteDTO.getStrPersonEmail();
            objCuenta.PersonMobilePhone = objDatosClienteDTO.getStrPersonHomePhone();
            objCuenta.Ter_Genero__pc = objDatosClienteDTO.getStrGenero();
            objCuenta.BillingPostalCode = objDatosClienteDTO.getStrPersonMailingPostalCode();
            objCuenta.Ter_Tipo_documento__pc = objDatosClienteDTO.getStrTipoDocumento();
            objCuenta.Ter_Pais_documento__pc = objDatosClienteDTO.getStrPaisDocumento();
            objCuenta.Ter_Numero_de_identificacion__c = objDatosClienteDTO.getStrNumeroIdentificacion();
            //objCuenta.PersonMailingStreet = objDatosClienteDTO.getStrPersonMailingStreet();
            objCuenta.BillingStreet = objDatosClienteDTO.getStrPersonMailingStreet();
            //objCuenta.PersonMailingCountry = objDatosClienteDTO.getStrPersonMailingCountry();
            objCuenta.BillingCountry = objDatosClienteDTO.getStrPersonMailingCountry();
            //objCuenta.PersonMailingState = objDatosClienteDTO.getStrPersonMailingState();
            objCuenta.BillingState = objDatosClienteDTO.getStrPersonMailingState();
            //objCuenta.PersonMailingCity = objDatosClienteDTO.getStrPersonMailingCity();
            objCuenta.BillingCity = objDatosClienteDTO.getStrPersonMailingCity();
            objCuenta.F_ClubTerpelAgreementAccepted__c = objDatosClienteDTO.getStrClubTerpelAgreementAccepted()=='Y'?true:false;
            objCuenta.F_ClubTerpelAgreementDate__c = objDatosClienteDTO.getDtClubTerpelAgreementDate();
            objCuenta.F_SessionId__c = objDatosClienteDTO.getStrSessionId();
            objCuenta.F_BalanceLifeMiles__c = objDatosClienteDTO.getStrBalanceLifeMiles()!=null?Decimal.valueOf(objDatosClienteDTO.getStrBalanceLifeMiles()):null;
            //Se pone el RecordType de tipo Cliente LifeMiles
            objCuenta.RecordTypeId = lstRecordTypeClienteLifeMiles.get(0).Id;
            if(!String.isBlank(objDatosClienteDTO.getStrSolicitudTarjetaLM())){
				objCuenta.F_CodigoEstadoTarjetaLM__c = objDatosClienteDTO.getStrSolicitudTarjetaLM();
			}
            
            if(!blnCuentaExiste){
            	objCuenta.OwnerId = this.lstProgram.get(0).OwnerId;
            }
            
            if(objDatosClienteDTO.isBlnClubTerpelAgreementAccepted()){
                if(!blnCuentaExiste){
                    //Se debe poner en true el campo para disparar el trigger de creacion de Member
                    objCuenta.F_CreateMember__c = true;
                    system.debug('=====>>>>> [Cuenta NO existe] Se seleccionó el campo F_CreateMember__c para que el Trigger de Fielo se Dispare.');
                } else if(!objCuenta.F_CreateMember__c){
                    objCuenta.F_CreateMember__c = true;
                    system.debug('=====>>>>> [Cuenta SI existe] Se seleccionó el campo F_CreateMember__c para que el Trigger de Fielo se Dispare.');
                }
            }
            
            system.debug('=====>>>>> Va a hacer Upsert sobre la cuenta. Cuenta Existe: ' + blnCuentaExiste);
            try{
                upsert objCuenta;
                system.debug('************* HIZO UPSERT CUENTA *****************');
            } catch(Exception e){
                System.Debug('====================== EXCEPCION TerpelAutentication ======================');
                System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                System.Debug('===========================================================================');
                strHTMLError = paginaError(label.Ter_lbl_Error_Generico_Registro_Clientes );
                return;
            }
            
            login();
        } 
        
    }
    
}