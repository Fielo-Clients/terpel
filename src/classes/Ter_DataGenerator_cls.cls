/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez (WRM)
Proyecto: Terpel
Descripción: Clase encargada de generar la data para todas las clases de prueba. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 13-02-2017  Walter Rodríguez M (WRM)      Creación de la Clase.
***********************************************************************************/

public class Ter_DataGenerator_cls 
{
    public static Contact objContact;
    public static Account objAccount;
    public static Event objEvent;
    public static Task objTask;
    public static Ter_Estacion_de_Servicio__c objEDS;
    public static Attachment objAtt;
    public static Product2 objProduct;
    public static Ter_Acta_Encuesta__c objActa;
    public static EventWhoRelation objWhoRelation;
    public static Contract objContract;
    
    public static Account crearCuenta(Boolean isInsert)
    {
        objAccount = new Account();
        objAccount.Ter_Codigo_Solicitante__c = '123456';
        objAccount.Name = 'Test';
        objAccount.AccountNumber = '654321';
        objAccount.Ter_Zona__c = 321;
        objAccount.Ter_Nombre_Ejecutivo__c = UserInfo.getUserId();
        objAccount.Ter_Estado_de_cliente__c = 'Contacto';
        objAccount.BillingStreet = 'Calle 138';
        objAccount.BillingCity = 'Bogota';
        objAccount.BillingCountry = 'Colombia';
        objAccount.BillingState = 'Cundinamarca';
        //objAccount.Ter_Estado_de_cliente__c = 'Visita';
        
        if(isInsert)
        {
            insert objAccount;
        }
        return objAccount; 
        
    }
    
    public static Account crearCuentaAcumulacion(boolean doInsert){
    	Account objCuenta = new Account();
    	
    	list<FieloPLT__Program__c> lstProgram;
		lstProgram = [SELECT OwnerId FROM FieloPLT__Program__c WHERE Name = :label.Ter_lbl_Nombre_Programa_Club_Terpel];
		
		list<RecordType> lstRecordTypeClienteLifeMiles;
		lstRecordTypeClienteLifeMiles = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Fielo_ClienteTerpel'];
		
		objCuenta.F_NumeroLifeMiles__c = '1983002834993';
		objCuenta.FirstName = 'Cliente';
		objCuenta.MiddleName = 'Para';
		objCuenta.LastName = 'Pruebas';
		objCuenta.Suffix = 'Avanxo';
		objCuenta.PersonBirthdate = Date.valueOf('1985-12-03');
		objCuenta.PersonEmail = 'correo49875@hotmail.com';
		objCuenta.PersonMobilePhone = '3215659874';
		objCuenta.Ter_Genero__pc = null;
		objCuenta.PersonMailingPostalCode = null;
		objCuenta.Ter_Tipo_documento__pc = 'Cédula de ciudadanía';
		objCuenta.Ter_Pais_documento__pc = '7610';
		objCuenta.Ter_Numero_de_identificacion__c = '90000009';
		objCuenta.BillingStreet = 'Bogota';
		objCuenta.BillingCountry = '7610';
		objCuenta.BillingState = '2545';
		objCuenta.BillingCity = '0001';
		objCuenta.F_ClubTerpelAgreementAccepted__c = true;
		objCuenta.F_ClubTerpelAgreementDate__c = Date.valueOf('2017-06-14');
		objCuenta.F_SessionId__c = '0000997135';
		objCuenta.F_BalanceLifeMiles__c = null;
		objCuenta.OwnerId = lstProgram.get(0).OwnerId;
		objCuenta.RecordTypeId = lstRecordTypeClienteLifeMiles.get(0).Id;
    	
    	if(doInsert)
        {
            insert objCuenta;
        }
        return objCuenta; 
    }
    
    public static Contact crearContacto(Boolean isInsert, Account objAcc)
    {
        objContact = new Contact();
        objContact.FirstName = 'Pepe';
        objContact.LastName = 'Perez';
        objContact.AccountId = objAcc.Id;
        objContact.Ter_Categoria__c = 'Alta';
        objContact.Email = 'pruebas@micorreo.com';
        objContact.Ter_Soporte_habeas_data_fisico__c = 'www.google.com';
        
        if(isInsert)
        {
            insert objContact;
        }
        return objContact;
    }
    
    public static Ter_Estacion_de_Servicio__c crearEDS(Boolean IsInsert)
    {
        objEDS = new Ter_Estacion_de_Servicio__c();
        objEDS.Name = 'EDS Prueba';
        objEDS.Ter_Direccion__c = 'Cra 137';
        objEDS.Ter_Ciudad__c = 'Bogota';
        objEDS.Ter_Departamento__c = 'Cundinamarca';
        objEDS.Ter_Marca__c = 'Terpel';
        objEDS.Ter_Segmento__c = 'EDS OPESE';
        objEDS.Ter_Codigo_unico__c = '1234';
        objEDS.F_IdFidelizacion__c = '1234';
        objEDS.Ter_Estatus__c = 'Activa';
        objEDS.F_Acumula__c = true;
        objEDS.F_ClubTerpel__c = true;
        //objEDS.F_IdFidelizacion__c = '88789';
        objEDS.Ter_Nombre_jefe_de_zona__c = UserInfo.getUserId();
        
        if(isInsert)
        {
            insert objEDS;
        }
        return objEDS;
    }
    
    public static Event crearEvento(Boolean IsInsert, Account objAcc, String strTipoActa)
    {
        objEvent = new Event();
        objEvent.Subject = 'Otro';
        objEvent.Location = 'Norte';
        objEvent.StartDateTime = system.now();
        objEvent.EndDateTime = system.now().addHours(3);
        objEvent.Ter_Estado_evento__c = 'Programada';
        objEvent.OwnerId = UserInfo.getUserId();
        objEvent.Ter_Tipo_Acta__c = strTipoActa;
        objEvent.whatId = objAcc.Id;
        
        if(isInsert)
        {
            insert objEvent;
        }
        return objEvent;
    }
    
    public static Event crearEventoEDS(Boolean isInsert, Ter_Estacion_de_Servicio__c objEstacionServi, Contact objContacto)
    {
        objEvent = new Event();
        objEvent.Subject = 'Otro';
        objEvent.Location = 'Norte';
        objEvent.StartDateTime = system.now();
        objEvent.EndDateTime = system.now().addHours(3);
        objEvent.Ter_Estado_evento__c = 'Programada';
        objEvent.OwnerId = UserInfo.getUserId();
        objEvent.Ter_Tipo_Acta__c = 'Acta Bitácora Ambiental GA';
        objEvent.whatId = objEstacionServi.Id;
        objEvent.whoId = objContacto.Id;
        
        if(isInsert)
        {
            insert objEvent;
        }
        return objEvent;
    }
    
    /*public static EventWhoRelation crearAsistentesEvento(Boolean isInsert, Event objEvento, Contact objContacto)
    {
        objWhoRelation = new EventWhoRelation();
        objWhoRelation.EventId = objEvento.Id;
        objWhoRelation.RelationId = objContacto.Id;
        
        if(isInsert)
        {
            insert objWhoRelation;
        }
        return objWhoRelation;
    }*/
    
    public static Ter_Acta_Encuesta__c crearPDF(Boolean isInsert)
    {
        objEDS = new Ter_Estacion_de_Servicio__c();
        objEDS.Name = 'EDS Prueba';
        objEDS.Ter_Direccion__c = 'Cra 137';
        objEDS.Ter_Ciudad__c = 'Bogota';
        objEDS.Ter_Departamento__c = 'Cundinamarca';
        objEDS.Ter_Marca__c = 'Terpel';
        objEDS.Ter_Segmento__c = 'Opese';
        objEDS.Ter_Codigo_unico__c = '1234';
        if(isInsert)
        {
            insert objEDS;
            
            objEvent = new Event();
            objEvent.Subject = 'Otro';
            objEvent.Location = 'Norte';
            objEvent.StartDateTime = system.now().addMinutes(30);
            objEvent.EndDateTime = system.now().addHours(3);
            objEvent.Ter_Estado_evento__c = 'Programada';
            objEvent.OwnerId = UserInfo.getUserId();
            objEvent.Ter_Tipo_Acta__c = 'Acta Bitácora Ambiental GA';
            objEvent.whatId = objEDS.Id;
            
            objActa = new Ter_Acta_Encuesta__c();
            objActa.Ter_Nombre_EDS__c = objEDS.Id;
            
            insert objEvent;
            insert objActa;
        }
        
        return objActa;
    }
    
    public static Task crearTarea(Boolean IsInsert, Account objAcc)
    {
        objTask = new Task();
        objTask.Subject = 'Otro';
        objTask.ActivityDate = system.today();
        objTask.Priority = 'Normal';
        objTask.Status = 'Abierta';
        objTask.OwnerId = UserInfo.getUserId();
        objTask.whatId = objAcc.Id;
        
        if(isInsert)
        {
            insert objTask;
        }
        return objTask;
    }
    
    public static Attachment creaAdjunto(Boolean isInsert, Account objAcc)
    {
        objAtt= new Attachment();
        objAtt.Name = 'Prueba.txt';
        objAtt.Body = blob.valueOf('PRUEBA');
        objAtt.ParentId = objAcc.Id;
        
        if(isInsert)
        {
            insert objAtt;
        }
        return objAtt;
    }
    
    public static Product2 creaProducto(Boolean isInsert)
    {
        objProduct = new Product2();
        objProduct.Name = 'Regalo Prueba';
        objProduct.ProductCode = '123';
        objProduct.Family = 'Alta';
        objProduct.Description = 'Descripción Test';
        objProduct.Ter_Imagen__c = 'Imagen de prueba';
        objProduct.Ter_Propietario__c = UserInfo.getUserId();
        objProduct.IsActive = true;
    
        if(isInsert)
        {
            insert objProduct;
        }
        return objProduct;
    }
    
    public static Ter_Acta_Encuesta__c creaActa(Boolean isInsert, Ter_Estacion_de_Servicio__c objEstacion)
    {
        objActa = new Ter_Acta_Encuesta__c();
        objActa.Ter_Nombre_EDS__c = objEstacion.Id;
        
        if(isInsert)
        {
            insert objActa;
        }
        return objActa;
    }
    
    public static Contract creaContrato(Boolean isInsert, Account objCuen)
    {
        objContract = new Contract();
        objContract.Ter_Numero_de_contrato__c = '123321';
        objContract.Name = 'Contrato test';
        objContract.AccountId = objCuen.Id;
        objContract.Status = 'EN TRAMITE';
        objContract.Ter_Titulo__c ='Titulo Test';
        objContract.Ter_Valor_del_Contrato__c = 3000000;
        objContract.Ter_Moneda__c = 'Pesos';
        objContract.StartDate = system.today();
        objContract.Ter_Fecha_de_Fin__c = system.today().addMonths(3);
        
        if(isInsert)
        {
            insert objContract;
        }
        return objContract;
    }

    /**
     * Metodo responsable de generar el request del servicio de conversion de millas.
     * @param request el objeto que desea llenar <code>null</code> para generar un objeto nuevo.
     * @return request generado.
     */
    public static Ter_ConversionWsRequestDTO_cls generateRequestConversion
                                        (Ter_ConversionWsRequestDTO_cls request) {
        if (request == null) {
            request = new Ter_ConversionWsRequestDTO_cls();
        }
        request.setUsername('cmosquera');
        request.setPassword('123456');
        request.setTransactionId('19871030105410000010');
        request.setTransactionIdSource('19871030105410000010');
        request.setMemberId('554545');
        request.setTransactionType('P');
        request.setPrepurchaseTrans('54545');
        request.setConversionMiles(1000);
        request.setPromotionalMiles(300);
        request.setSenderCode('44444');
        return request;
    }

    /**
     * Metodo encargado de generar el request de redencion.
     * @return el request generado.
     */
    public static Ter_RequestRedentionDTO_cls generateRquestRedention(Ter_RequestRedentionDTO_cls request) {
        if (request == null) {
            request = new Ter_RequestRedentionDTO_cls();
        }
        request.setMemberId('13428703035');
        request.setPartnerCode('44444');
        request.setUsername('cmosquera');
        request.setPassword('123456');
        request.setPostingAmount('100');
        request.setPostingEquivalent('4.85');
        request.setSession('0000113258');
        request.setTransactionDate('20160516');
        request.setTransactionDesc('Redencion de millas en Multiplaza');
        request.setTransactionType('D');
        request.setTransactionId('abc00001');
        request.setPassword2('123456789');
        request.setTransactionIdSource('Ts545454545');
        request.setDiscountAmount('500');
        List<Ter_RequestRedentionDTO_cls.AwardDTO> awards = new List<Ter_RequestRedentionDTO_cls.AwardDTO>();
        Ter_RequestRedentionDTO_cls.AwardDTO aw1 = new Ter_RequestRedentionDTO_cls.AwardDTO();
        aw1.setAwardCode('1');
        aw1.setAwardName('Award1');
        aw1.setAwardDetail('detail aw1');
        Ter_RequestRedentionDTO_cls.AwardDTO aw2 = new Ter_RequestRedentionDTO_cls.AwardDTO();
        aw2.setAwardCode('2');
        aw2.setAwardName('Award2');
        aw2.setAwardDetail('detail aw2');
        awards.add(aw1);
        awards.add(aw2);
        request.setAwards(awards);

        return request;
    }

    /**
     * Metodo encargado de generar una autorizacion de lifemiles.
     * @return autorizacion generada.
     */
    public static Fielo_Autorizacion_LifeMiles__c generateDataAuthFieloLifeMiles() {
        Fielo_Autorizacion_LifeMiles__c objAuth = new Fielo_Autorizacion_LifeMiles__c();
        objAuth.F_IdTransaccion__c = '19871030105410000010';
        objAuth.F_TipoTransaccion__c = 'Crédito (C)';
        objAuth.F_MillasBase__c = 1000;
        objAuth.F_MillasPromocionales__c=1000;
        objAuth.F_Estado__c = 'Pendiente';

        return objAuth;
    }

    /**
     * Metodo encargado de generar el request de validar cliente.
     * @return el request generado.
     */
    public static SrvIntClienteTransaccion_in.DT_ValidaCliente
            generateRequestValidateClient(String origenTransaccion, String codTipoidentificacion, String idNumber) {
        SrvIntClienteTransaccion_in.DT_ValidaCliente request =
                new SrvIntClienteTransaccion_in.DT_ValidaCliente();
        request.fechaTransaccion = '2017/10/01';
        request.idPuntoVenta = '10';
        if (origenTransaccion == null) {
            request.origenTransaccion = label.Ter_lbl_EDS;
        } else {
            request.origenTransaccion = origenTransaccion;
        }

        SrvIntClienteTransaccion_in.DT_Identificacion tipoDocumento =
                new SrvIntClienteTransaccion_in.DT_Identificacion();
        if (codTipoidentificacion == null) {
            tipoDocumento.codTipoidentificacion = Label.TER_NUMERO_LIFE_MILES_TYPE;
        }
        else {
            tipoDocumento.codTipoidentificacion = codTipoidentificacion;
        }

        if (idNumber == null) {
            tipoDocumento.valNumeroIdentificacion = '1128057876';
        }
        else {
            tipoDocumento.valNumeroIdentificacion = idNumber;
        }
        request.tipoDocumento = tipoDocumento;
        return request;
    }

    /**
     * Metodo encargado de generar la estacion de servicio.
     * @return el objeto de estacion servicio generado.
     */
    public static Ter_Estacion_de_Servicio__c generateEST() {
        Ter_Estacion_de_Servicio__c objEst = new Ter_Estacion_de_Servicio__c();
        objEst.F_Acumula__c = true;
        objEst.F_ClubTerpel__c = true;
        objEst.F_Reclama__c = true;
        objEst.F_Redime__c = true;
        objEst.Name = 'Estacion 1';
        objEst.F_IdFidelizacion__c='1234578';
        return objEst;
    }

    /**
     * Metodo encargado de generar la tienda de servicio.
     * @return el objeto de tienda servicio generado.
     */
    public static Ter_Negocio_Complementario__c generateStore() {
        Ter_Negocio_Complementario__c objStore = new Ter_Negocio_Complementario__c();
        objStore.F_Acumula__c = true;
        objStore.F_ClubTerpel__c = true;
        objStore.F_Reclama__c = true;
        objStore.F_Redime__c = true;
        objStore.Name = 'Estacion 1';
        objStore.Ter_Codigo_PDV__c = '1234';
        objStore.F_IdFidelizacion__c='123457';

        return objStore;
    }

	public static Ter_Negocio_Complementario__c crearTTCC(boolean doInsert) {
        Ter_Negocio_Complementario__c objTTCC = new Ter_Negocio_Complementario__c();
        objTTCC.F_Acumula__c = true;
        objTTCC.F_ClubTerpel__c = true;
        objTTCC.F_Reclama__c = true;
        objTTCC.F_Redime__c = true;
        objTTCC.Name = 'Estacion 1';
        objTTCC.Ter_Direccion__c = 'xxx';
        objTTCC.Ter_Ciudad__c = 'xxx';
        objTTCC.Ter_Departamento__c = 'xxx';
        objTTCC.Ter_Codigo_PDV__c = '1234';
        objTTCC.F_IdFidelizacion__c = '1234';
        if(doInsert){
        	insert objTTCC;
        }
        return objTTCC;
    }


    /**
     * Metodo encargado de generar un programa.
     * @return el programa generado.
     */
    public static FieloPLT__Program__c generateProgramFielo() {
        FieloPLT__Program__c program = new FieloPLT__Program__c();
        program.Name = 'Test';

        return program;
    }

     /**
     * Metodo encargado de generar un contacto.
     * @return el contacto generado.
     */
    public static Contact generateContact (){
        Contact contact = new Contact();
        contact.FirstName = 'Cristian';
        contact.LastName = 'Mosquera';
        contact.Email = 'cmp166@gmail.com';

        return contact;
    }

    /**
     * Metodo encargado de generar un member.
     * @return el member generado.
     */
    public static FieloPLT__Member__c generateMember
                (String lifeMilesNumber, String idNumber, String cardNumber, String statusMember) {
        FieloPLT__Member__c member = new FieloPLT__Member__c();
        member.F_NumeroLifeMiles__c = lifeMilesNumber;
        if (statusMember == null) {
            member.FieloPLT__Status__c = Label.TER_STATUS_ACTIVE_MEMBER;
        }
        else {
            member.FieloPLT__Status__c = statusMember;
        }
        member.F_NumeroTarjetaPreinscrita__c = cardNumber;
        member.F_IdentificationNumber__c = idNumber;
        member.F_PrimerNombre__c = 'Cristian';
        member.F_SegundoNombre__c = 'Jose';
        member.F_PrimerApellido__c = 'Mosquera';
        member.F_SegundoApellido__c = 'Puello';
        member.FieloPLT__Email__c = 'cmp166@gmail.com';
        member.F_SessionId__c = '1234567896AAaa';
        member.F_EstadoTarjetaPreinscrita__c = 'Activa';
        return  member;
    }

    /**
     * Metodo encargado de generar una configuracion personalizada de lifemiles
     * @return la configuracion generada.
     */
    public static Fielo_ParametrosLifeMiles__c generateCustomSettingsLifeMiles () {
        Fielo_ParametrosLifeMiles__c cs = new Fielo_ParametrosLifeMiles__c();
        cs.TER_PASSWORD__c = 'pwdTEPCO$2017#';
        cs.TER_SENDER_CODE__c = 'TEPCO';
        cs.TER_USERNAME__c = 'usrTEPCO';
        cs.TER_ENDPOINT__c = 'https://wstest.lifemiles.com/loy/wcfLifeMilesConversion/ws_LMConversion.svc/https11';
        cs.TER_TIMEOUT__c = 30000;
        cs.Name = 'Ter_Custom_Settings_WS';
        return cs;
    }

     /**
     * Metodo encargado de generar una configuracion personalizada general.
     * @return la configuracion generada.
     */
    public static Configuracion_General__c generateCustomSettingsGeneral() {
        Configuracion_General__c cs = new Configuracion_General__c();
        cs.Name = 'General';
        cs.Ter_Fielo_StarURL__c = 'https://devfie-clubterpel.cs66.force.com/fielo/';
        cs.Ter_IV_AES_LifeMiles__c = 'X6pUWkm6>5XAWNOw';
        cs.Ter_Limite_Edad_Clientes__c = 18;
        cs.Ter_Llave_AES_LifeMiles__c = 'aZz1XTGbQyky2cdktE2fr62K9Vl2Wt4e';
        cs.Ter_IV_AES_Terpel__c = 'mqWg&B7TNx[LFl*n';
        cs.Ter_Llave_AES_Terpel__c = 'u6LykvD8N3bq0EDkqQoqmm7dtMzgWLZ8';
        cs.Timeout_Nprinting__c = 30.000;
        return cs;
    }
    
    public static list<Ter_Codigos_Errores__c> generarCodigosError(boolean doInsert){
    	list<Ter_Codigos_Errores__c> lstCodErrores = new list<Ter_Codigos_Errores__c>();
		Ter_Codigos_Errores__c objCodError;
		
		objCodError = new Ter_Codigos_Errores__c();
		 objCodError.Ter_Codigo_Error__c = '000';
		 objCodError.Ter_Mensaje__c = 'Record processed successfully ';
		 objCodError.Ter_Proceso__c = 'Acumulacion';
		 objCodError.Name = 'Acumulacion - 000';
		lstCodErrores.add(objCodError);
		
		objCodError = new Ter_Codigos_Errores__c();
		 objCodError.Ter_Codigo_Error__c = '000';
		 objCodError.Ter_Mensaje__c = 'Record processed successfully ';
		 objCodError.Ter_Proceso__c = 'Registro Clientes';
		 objCodError.Name = 'Registro Clientes - 000';
		lstCodErrores.add(objCodError);
		
		objCodError = new Ter_Codigos_Errores__c();
		 objCodError.Ter_Codigo_Error__c = '001';
		 objCodError.Ter_Mensaje__c = 'LM account does not exist ';
		 objCodError.Ter_Proceso__c = 'Acumulacion';
		 objCodError.Name = 'Acumulacion - 001';
		lstCodErrores.add(objCodError);
		
		objCodError = new Ter_Codigos_Errores__c();
		 objCodError.Ter_Codigo_Error__c = '001';
		 objCodError.Ter_Mensaje__c = 'LM account does not exist ';
		 objCodError.Ter_Proceso__c = 'Registro Clientes';
		 objCodError.Name = 'Registro Clientes - 001';
		lstCodErrores.add(objCodError);
		
		
		objCodError = new Ter_Codigos_Errores__c();
		 objCodError.Ter_Codigo_Error__c = '005';
		 objCodError.Ter_Mensaje__c = 'Accrual transaction not found';
		 objCodError.Ter_Proceso__c = 'Acumulacion';
		 objCodError.Name = 'Acumulacion - 005';
		lstCodErrores.add(objCodError);
		
		
		objCodError = new Ter_Codigos_Errores__c();
		 objCodError.Ter_Codigo_Error__c = '009';
		 objCodError.Ter_Mensaje__c = 'Invalid period of time to revert transaction';
		 objCodError.Ter_Proceso__c = 'Registro Clientes';
		 objCodError.Name = 'Registro Clientes - 009';
		lstCodErrores.add(objCodError);
		
		if(doInsert){	
			insert lstCodErrores;
		}
		
		return lstCodErrores;
    }
    
    public static list<Ter_Homologacion_Listas__c> crearDatosHomologados(boolean doInsert){
    	
    	list<Ter_Homologacion_Listas__c> lstHomologacion_Listas = new list<Ter_Homologacion_Listas__c>();
		Ter_Homologacion_Listas__c objHomologacion_Listas;
		
		objHomologacion_Listas = new Ter_Homologacion_Listas__c();
		objHomologacion_Listas.Name = 'Account - TD - 01';
		objHomologacion_Listas.Ter_Campo__c = 'Ter_Tipo_documento__c';
		objHomologacion_Listas.Ter_Objeto__c = 'Account';
		objHomologacion_Listas.Ter_Valor_Externo__c = '01';
		objHomologacion_Listas.Ter_Valor_Homologado__c = 'Cédula de ciudadanía';
		lstHomologacion_Listas.add(objHomologacion_Listas);
		
		objHomologacion_Listas = new Ter_Homologacion_Listas__c();
		objHomologacion_Listas.Name = 'Account - TD - 05';
		objHomologacion_Listas.Ter_Campo__c = 'Ter_Tipo_documento__c';
		objHomologacion_Listas.Ter_Objeto__c = 'Account';
		objHomologacion_Listas.Ter_Valor_Externo__c = '05';
		objHomologacion_Listas.Ter_Valor_Homologado__c = 'PA';
		lstHomologacion_Listas.add(objHomologacion_Listas);
		
		objHomologacion_Listas = new Ter_Homologacion_Listas__c();
		objHomologacion_Listas.Name = 'Account - PD - 7610';
		objHomologacion_Listas.Ter_Campo__c = 'Ter_Pais_documento__c';
		objHomologacion_Listas.Ter_Objeto__c = 'Account';
		objHomologacion_Listas.Ter_Valor_Externo__c = '7610';
		objHomologacion_Listas.Ter_Valor_Homologado__c = 'Argentina';
		lstHomologacion_Listas.add(objHomologacion_Listas);
		
		objHomologacion_Listas = new Ter_Homologacion_Listas__c();
		objHomologacion_Listas.Name = 'Account - PD - 8010';
		objHomologacion_Listas.Ter_Campo__c = 'Ter_Pais_documento__c';
		objHomologacion_Listas.Ter_Objeto__c = 'Account';
		objHomologacion_Listas.Ter_Valor_Externo__c = '8010';
		objHomologacion_Listas.Ter_Valor_Homologado__c = 'Colombia';
		lstHomologacion_Listas.add(objHomologacion_Listas);
		
		objHomologacion_Listas = new Ter_Homologacion_Listas__c();
		objHomologacion_Listas.Name = 'Fielo_Venta__c - TT - Acumulacion';
		objHomologacion_Listas.Ter_Campo__c = 'F_TipoTransaccion__c';
		objHomologacion_Listas.Ter_Objeto__c = 'Fielo_Venta__c';
		objHomologacion_Listas.Ter_Valor_Externo__c = 'Acumulacion';
		objHomologacion_Listas.Ter_Valor_Homologado__c = 'Acumulación';
		lstHomologacion_Listas.add(objHomologacion_Listas);
		
		objHomologacion_Listas = new Ter_Homologacion_Listas__c();
		objHomologacion_Listas.Name = 'Fielo_Venta__c - TT - XX';
		objHomologacion_Listas.Ter_Campo__c = 'F_TipoTransaccion__c';
		objHomologacion_Listas.Ter_Objeto__c = 'Fielo_Venta__c';
		objHomologacion_Listas.Ter_Valor_Externo__c = 'XX';
		objHomologacion_Listas.Ter_Valor_Homologado__c = 'XX';
		lstHomologacion_Listas.add(objHomologacion_Listas);
		
		objHomologacion_Listas = new Ter_Homologacion_Listas__c();
		objHomologacion_Listas.Name = 'Fielo_Venta__c - OV - ' + label.Ter_lbl_EDS;
		objHomologacion_Listas.Ter_Campo__c = 'F_OrigenVenta__c';
		objHomologacion_Listas.Ter_Objeto__c = 'Fielo_Venta__c';
		objHomologacion_Listas.Ter_Valor_Externo__c = label.Ter_lbl_EDS;
		objHomologacion_Listas.Ter_Valor_Homologado__c = 'Estación de Servicio';
		lstHomologacion_Listas.add(objHomologacion_Listas);
		
		objHomologacion_Listas = new Ter_Homologacion_Listas__c();
		objHomologacion_Listas.Name = 'Fielo_Venta__c - OV - ' + label.Ter_lbl_TDC;
		objHomologacion_Listas.Ter_Campo__c = 'F_OrigenVenta__c';
		objHomologacion_Listas.Ter_Objeto__c = 'Fielo_Venta__c';
		objHomologacion_Listas.Ter_Valor_Externo__c = label.Ter_lbl_TDC;
		objHomologacion_Listas.Ter_Valor_Homologado__c = 'Tienda';
		lstHomologacion_Listas.add(objHomologacion_Listas);
		
		objHomologacion_Listas = new Ter_Homologacion_Listas__c();
		objHomologacion_Listas.Name = 'Fielo_Venta__c - OV - XX';
		objHomologacion_Listas.Ter_Campo__c = 'F_OrigenVenta__c';
		objHomologacion_Listas.Ter_Objeto__c = 'Fielo_Venta__c';
		objHomologacion_Listas.Ter_Valor_Externo__c = 'XX';
		objHomologacion_Listas.Ter_Valor_Homologado__c = 'Tienda';
		lstHomologacion_Listas.add(objHomologacion_Listas);
		
		objHomologacion_Listas = new Ter_Homologacion_Listas__c();
		objHomologacion_Listas.Name = 'Fielo_Venta__c - OV - XWXW';
		objHomologacion_Listas.Ter_Campo__c = 'F_OrigenVenta__c';
		objHomologacion_Listas.Ter_Objeto__c = 'Fielo_Venta__c';
		objHomologacion_Listas.Ter_Valor_Externo__c = 'XWXW';
		objHomologacion_Listas.Ter_Valor_Homologado__c = 'Tienda';
		lstHomologacion_Listas.add(objHomologacion_Listas);
		
		objHomologacion_Listas = new Ter_Homologacion_Listas__c();
		objHomologacion_Listas.Name = 'Fielo_Venta__c - TV - L';
		objHomologacion_Listas.Ter_Campo__c = 'F_TipoVenta__c';
		objHomologacion_Listas.Ter_Objeto__c = 'Fielo_Venta__c';
		objHomologacion_Listas.Ter_Valor_Externo__c = 'L';
		objHomologacion_Listas.Ter_Valor_Homologado__c = 'Líquidos';
		lstHomologacion_Listas.add(objHomologacion_Listas);
		
		objHomologacion_Listas = new Ter_Homologacion_Listas__c();
		objHomologacion_Listas.Name = 'FieloPLT__Member__c - TiT - CC';
		objHomologacion_Listas.Ter_Campo__c = 'F_IdentificationType__c';
		objHomologacion_Listas.Ter_Objeto__c = 'FieloPLT__Member__c';
		objHomologacion_Listas.Ter_Valor_Externo__c = 'CC';
		objHomologacion_Listas.Ter_Valor_Homologado__c = 'Cédula de ciudadanía';
		lstHomologacion_Listas.add(objHomologacion_Listas);
		
		if(doInsert){	
			insert lstHomologacion_Listas;
		}
		
		return lstHomologacion_Listas;
    	
    }
    
    public static FieloPLT__Program__c crearFieloProgram(boolean doInsert){
		
		FieloPLT__Program__c objFieloPLTProgram = new FieloPLT__Program__c();
		objFieloPLTProgram.Name = 'Club Terpel';
		objFieloPLTProgram.FieloPLT__ActualPointCost__c = null;
		objFieloPLTProgram.FieloPLT__CriteriaFields__c = '{"segments":{"pointLookupByObject":{},"isUsingCriterionGroup":false,"isMasterDetail":false,"isCrossField":false,"fieldsByObject":{"FieloPLT__Member__c":["F_NombreTipoDeRegistro__c"]}},"levels":{"pointLookupByObject":{},"isUsingCriterionGroup":false,"isMasterDetail":false,"isCrossField":false,"fieldsByObject":{}}}';
		objFieloPLTProgram.FieloPLT__NumberOfVoucherDigits__c = 16.0;
		objFieloPLTProgram.FieloPLT__OnlineTransactionProcessing__c = true;
		objFieloPLTProgram.FieloPLT__RequestMemberAuthorization__c = false;
		objFieloPLTProgram.FieloPLT__RequestRedemptionAuthorization__c = false;
		objFieloPLTProgram.FieloPLT__RequestUser__c = false;
		objFieloPLTProgram.SiteDomain__c = 'devfie-clubterpel.cs66.force.com';
		
		if(doInsert){	
			insert objFieloPLTProgram;
		}
		
		return objFieloPLTProgram;
		
	}
	
    public static FieloPLT__Segment__c crearSegmento(boolean doInsert, Id idProgram){
		
		list<RecordType> lstRT = [SELECT Id FROM RecordType WHERE SobjectType = 'FieloPLT__Segment__c' AND DeveloperName = 'Public'];
		
		FieloPLT__Segment__c objFieloPLSegment = new FieloPLT__Segment__c();
		objFieloPLSegment.Name = 'Público';
		objFieloPLSegment.RecordTypeId = lstRT.get(0).Id;
		objFieloPLSegment.FieloPLT__IsActive__c = true;
		objFieloPLSegment.FieloPLT__Program__c = idProgram;
		
		if(doInsert){	
			insert objFieloPLSegment;
		}
		
		return objFieloPLSegment;
		
	}
	
    public static FieloPLT__PointType__c crearFieloPointType(boolean doInsert){
		
		FieloPLT__PointType__c objFieloPLTPointType = new FieloPLT__PointType__c();
		objFieloPLTPointType.FieloPLT__MemberBalanceField__c = 'FieloPLT__Points__c';
		objFieloPLTPointType.FieloPLT__RedemptionBalanceField__c = 'FieloPLT__Points__c';
		objFieloPLTPointType.FieloPLT__RedemptionItemBalanceField__c = 'FieloPLT__Points__c';
		objFieloPLTPointType.FieloPLT__RewardBalanceField__c = 'FieloPLT__Points__c';
		objFieloPLTPointType.FieloPLT__TransactionBalanceField__c = 'FieloPLT__Points__c';
		objFieloPLTPointType.FieloPLT__ConversionModeField__c = 'FieloPLT__PointConversionMode__c';
		objFieloPLTPointType.FieloPLT__ConversionValueField__c = 'FieloPLT__ConversionValue__c';
		objFieloPLTPointType.FieloPLT__RecordFieldNameField__c = 'FieloPLT__RecordFieldName__c';
		objFieloPLTPointType.FieloPLT__MonthsUntilExpirationField__c = 'FieloPLT__MonthsUntilExpiration__c';
		objFieloPLTPointType.F_TarifaMillaUSD__c = 0.0095;
		
		if(doInsert){	
			insert objFieloPLTPointType;
		}
		
		return objFieloPLTPointType;
		
	}
	
    public static FieloPLT__ProgramPointType__c crearProgramPointType(boolean doInsert, Id idProgram, Id idPointType){
		
		FieloPLT__ProgramPointType__c objFieloPLTProgramPointType = new FieloPLT__ProgramPointType__c();
		objFieloPLTProgramPointType.FieloPLT__AuditPoints__c = true;
		objFieloPLTProgramPointType.FieloPLT__ExpirationMode__c = 'None';
		objFieloPLTProgramPointType.FieloPLT__PointType__c = idPointType;
		objFieloPLTProgramPointType.FieloPLT__Program__c = idProgram;
		objFieloPLTProgramPointType.FieloPLT__RequestPointApproval__c = false;
		objFieloPLTProgramPointType.FieloPLT__UniqueKey__c = 'a0Z0v0000004Z5tEAEa0V0v0000004FYXEA2';
		
		if(doInsert){	
			insert objFieloPLTProgramPointType;
		}
		
		return objFieloPLTProgramPointType;
		
	}
	
	public static Fielo_MedioDePago__c crearMedioPago(boolean doInsert){
		Fielo_MedioDePago__c objMedioPago = new Fielo_MedioDePago__c();
		objMedioPago.Name = 'Efectivo';
		objMedioPago.F_IdMedioDePagoEDS__c = '1';
		objMedioPago.F_IdMedioDePagoTTCC__c = '1';
		objMedioPago.F_Estado__c = 'Activo';
		objMedioPago.F_Acumula__c = true;
		
		if(doInsert){	
			insert objMedioPago;
		}
		
		return objMedioPago;
	}
	
	public static Fielo_MedioDePago__c crearMedioPagoMillas(boolean doInsert){
		Fielo_MedioDePago__c objMedioPago = new Fielo_MedioDePago__c();
		objMedioPago.Name = 'Millas LifeMiles';
		objMedioPago.F_IdMedioDePagoEDS__c = '1';
		objMedioPago.F_IdMedioDePagoTTCC__c = '1';
		objMedioPago.F_Estado__c = 'Activo';
		objMedioPago.F_Acumula__c = true;
		
		if(doInsert){	
			insert objMedioPago;
		}
		
		return objMedioPago;
	}
	
	public static Fielo_MedioDePago__c crearMedioPagoBono(boolean doInsert){
		Fielo_MedioDePago__c objMedioPago = new Fielo_MedioDePago__c();
		objMedioPago.Name = 'Bono Fidelización';
		objMedioPago.F_IdMedioDePagoEDS__c = '1';
		objMedioPago.F_IdMedioDePagoTTCC__c = '1';
		objMedioPago.F_Estado__c = 'Activo';
		objMedioPago.F_Acumula__c = true;
		
		if(doInsert){	
			insert objMedioPago;
		}
		
		return objMedioPago;
	}
	
	public static Fielo_VariablesFraude__c crearVariablesFraude(boolean doInsert){
		Fielo_VariablesFraude__c  objFieloVariablesFraude = new Fielo_VariablesFraude__c();
		
		objFieloVariablesFraude.Name = 'Fielo - Club Terpel';
		objFieloVariablesFraude.F_MaxInfracciones__c = 20;
		objFieloVariablesFraude.F_MaxCantidadVentasLiquido__c = 20;
		objFieloVariablesFraude.F_MaxCantidadVentasTienda__c = 20;
		objFieloVariablesFraude.F_CodigosCombustibleCorriente__c = '1,2,3';
		objFieloVariablesFraude.F_CodigosCombustibleDiesel__c = '4,5,6';
		objFieloVariablesFraude.F_CodigosCombustibleExtra__c = '7,8,9';
		objFieloVariablesFraude.F_MaxGalonesCorriente__c = 50;
		objFieloVariablesFraude.F_MaxGalonesDiesel__c = 60;
		objFieloVariablesFraude.F_MaxGalonesExtra__c = 55;
		objFieloVariablesFraude.F_MaxMontoVentaTienda__c = 500000;
		objFieloVariablesFraude.F_PeriodoInfracciones__c = 999;
		objFieloVariablesFraude.F_MinTiempoEntreVentas__c = 1;

		if(doInsert){	
			insert objFieloVariablesFraude;
		}
		
		return objFieloVariablesFraude;
	}
	
	public static list<Fielo_RedirectURLs_ClubTerpel__c> crearRedirectURLs(boolean doInsert){
		list<Fielo_RedirectURLs_ClubTerpel__c> lstRedirectURLs;
		Fielo_RedirectURLs_ClubTerpel__c objRedirectURLs;
		
		lstRedirectURLs = new list<Fielo_RedirectURLs_ClubTerpel__c>();
		
		objRedirectURLs = new Fielo_RedirectURLs_ClubTerpel__c();
		objRedirectURLs.Name = 'Fielo_URLHomeClienteLifeMiles';
		objRedirectURLs.F_URL__c = 'https://devfie-clubterpel.cs66.force.com/FieloCMS__Page?navId=a0u0v0000000cng';
		lstRedirectURLs.add(objRedirectURLs);
		
		objRedirectURLs = new Fielo_RedirectURLs_ClubTerpel__c();
		objRedirectURLs.Name = 'Fielo_URLHomeClienteTerpel';
		objRedirectURLs.F_URL__c = 'https://devfie-clubterpel.cs66.force.com/FieloCMS__Page?navId=a0u0v0000000cng';
		lstRedirectURLs.add(objRedirectURLs);
		
		objRedirectURLs = new Fielo_RedirectURLs_ClubTerpel__c();
		objRedirectURLs.Name = 'Fielo_URLPrimerLoginClienteTerpel';
		objRedirectURLs.F_URL__c = 'https://devfie-clubterpel.cs66.force.com/FieloCMS__Page?navId=a0u0v0000000r1e';
		lstRedirectURLs.add(objRedirectURLs);
		
		if(doInsert){
			insert lstRedirectURLs;
		}
		
		return lstRedirectURLs;
		
	}


    public static FieloPLT__Redemption__c crearRedenciones(Id idMember, boolean doInsert) {
        FieloPLT__Redemption__c  objFieloPLTRedemption = new FieloPLT__Redemption__c();
        objFieloPLTRedemption.FieloPLT__Member__c = idMember;
        objFieloPLTRedemption.FieloPLT__Status__c = 'Closed';

        if(doInsert){   
            insert objFieloPLTRedemption;
        }
        
        return objFieloPLTRedemption;
    }

    public static FieloPLT__Reward__c crearPremio(Id idProgram, Id idSegment, boolean doInsert) {
        FieloPLT__Reward__c objFieloReward = new FieloPLT__Reward__c();
        objFieloReward.FieloPLT__IsInstantReward__c = false;
        objFieloReward.FieloPLT__Points__c = 50;
        objFieloReward.FieloPLT__Program__c = idProgram;
        objFieloReward.FieloPLT__Segment__c = idSegment;
        objFieloReward.FieloPLT__StockManagement__c = 'Unlimited';
        objFieloReward.FieloPLT__Stock__c = 0;
        objFieloReward.FieloPLT__UniqueVoucher__c = false;
        objFieloReward.F_Monto__c = 10000;
        objFieloReward.Name = 'Bono 10000 COP';

         if(doInsert){   
            insert objFieloReward;
        }
        
        return objFieloReward;
    }

    public static FieloPLT__RedemptionItem__c crearItemRedencion(Id idRedencion, Id idPremio, boolean doInsert) {
        FieloPLT__RedemptionItem__c objFieloRedemptionItem = new FieloPLT__RedemptionItem__c();
        objFieloRedemptionItem.FieloPLT__Redemption__c = idRedencion;
        objFieloRedemptionItem.FieloPLT__Reward__c = idPremio;
        objFieloRedemptionItem.FieloPLT__Status__c = 'Listo';
        objFieloRedemptionItem.FieloPLT__Quantity__c = 1;

        if(doInsert){   
            insert objFieloRedemptionItem;
        }
        
        return objFieloRedemptionItem;

    }
    
}