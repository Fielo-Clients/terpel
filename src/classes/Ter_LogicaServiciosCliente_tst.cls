/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de realizar las pruebas unitarias de
*                   los metodos de la clase Ter_LogicaServiciosCliente_cls.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		6/06/2017		Cristian Mosquera (CM)		Implementacion
*                                                                     inicial de la clase de prueba.
**/
@isTest
public class Ter_LogicaServiciosCliente_tst {


    @isTest
    public static void testValidarCliente () {
        Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert cs;
        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert csp;
        Ter_LogicaServiciosCliente_cls logicaServiciosCliente_cls =
                new Ter_LogicaServiciosCliente_cls();
        SrvIntClienteTransaccion_in.DT_ValidaCliente objValidaCliente =
                                new SrvIntClienteTransaccion_in.DT_ValidaCliente();
        //objValidaCliente.tipoDocumento.valNumeroIdentificacion = '1MX2sIt0LYAcgrPUhrGK1A==';

        SrvIntClienteTransaccion_in.DT_ValidarResponse objResponse =
                                        logicaServiciosCliente_cls.validarCliente(objValidaCliente);

        System.assert(objResponse.validaClienteRes.mensajePer.contains(Label.TER_ERROR_MSG_TRANSACTION_SOURCE_EMPTY));
        System.assert(objResponse.validaClienteRes.mensajePer.contains(Label.TER_ERROR_MSG_STORE_EMPTY));
        System.assert(objResponse.validaClienteRes.mensajePer.contains(Label.TER_ERROR_MSG_DATE_TRANSACTION_EMPTY));
        System.assert(objResponse.validaClienteRes.mensajePer.contains(Label.TER_ERROR_MSG_ID_TYPE_EMPTY));

        System.debug('---> error'+ objResponse.validaClienteRes.confirm);

        System.assert(!objResponse.validaClienteRes.confirm);
        SrvIntClienteTransaccion_in.DT_Identificacion tipoDocumento =
                            new SrvIntClienteTransaccion_in.DT_Identificacion();
        tipoDocumento.codTipoidentificacion = 'X';
        objValidaCliente.tipoDocumento = tipoDocumento;
        objValidaCliente.tipoDocumento.valNumeroIdentificacion = null;
        objResponse =
                logicaServiciosCliente_cls.validarCliente(objValidaCliente);

        System.assert(objResponse.validaClienteRes.mensajePer.contains(Label.TER_ERROR_MSG_ID_NUMBER_EMPTY));
        System.assert(!objResponse.validaClienteRes.confirm);

        objResponse =  testClientByidType
                (Label.Fielo_ClienteInexistente , label.Ter_lbl_EDS, null, null,
                        '1128057876', null, 'JEFSoiBspcfctWZr9wloWg==', Label.TER_STATUS_ACTIVE_MEMBER);

        System.debug('objResponse.Error-->>' + objResponse.validaClienteRes.mensajePer);
        System.assert(objResponse.validaClienteRes.confirm);
        System.assert(objResponse.validaClienteRes.nombreCliente.contains('1128057876'));


        objResponse =  testClientByidType
                (Label.Fielo_TarjetaPreinscritaInexistente, label.Ter_lbl_EDS,
                        Label.TER_TARJETA_PREINSCRITA_TYPE, null, null, '1128057876',
                        'JEFSoiBspcfctWZr9wloWg==', Label.TER_STATUS_ACTIVE_MEMBER );

        System.assert(objResponse.validaClienteRes.confirm);
        System.assert(objResponse.validaClienteRes.nombreCliente.contains('Cristian Jose Mosquera Puello'));


        objResponse =  testClientByidType
                (Label.Fielo_ClienteInexistente, label.Ter_lbl_TDC,
                        'CC', '1128057876', '1454545', null, 'JEFSoiBspcfctWZr9wloWg==', Label.TER_STATUS_ACTIVE_MEMBER);

        System.debug('objResponse.Error-->>' + objResponse.validaClienteRes.mensajePer);
        System.assert(objResponse.validaClienteRes.confirm);
        System.assert(objResponse.validaClienteRes.nombreCliente.contains('Cristian Jose Mosquera Puello'));



    }


    private static SrvIntClienteTransaccion_in.DT_ValidarResponse testClientByidType
                            (String errorNotFound, String origenTransaccion,
                                    String codTipoidentificacion,String idNumber,
                                    String lifeMilesNumber,  String cardNumber, String idReqNumber,
                                    String statusMember) {

        Ter_LogicaServiciosCliente_cls logicaServiciosCliente_cls =
                new Ter_LogicaServiciosCliente_cls();
        Account account = Ter_DataGenerator_cls.crearCuenta(true);


        SrvIntClienteTransaccion_in.DT_ValidaCliente objValidaCliente =
                Ter_DataGenerator_cls.generateRequestValidateClient
                            (origenTransaccion, codTipoidentificacion, idReqNumber);

        Ter_Negocio_Complementario__c objStore = Ter_DataGenerator_cls.generateStore();
        objStore.F_Acumula__c = false;
        objStore.F_ClubTerpel__c = false;

        insert objStore;

        Ter_Estacion_de_Servicio__c objEst = Ter_DataGenerator_cls.generateEST();

        objEst.F_Acumula__c = false;
        objEst.F_ClubTerpel__c = false;
        insert objEst;

        if (label.Ter_lbl_EDS.equals(origenTransaccion)) {
            objValidaCliente.idPuntoVenta = objEst.F_IdFidelizacion__c;
        }
        else if (label.Ter_lbl_TDC.equals(origenTransaccion)) {
            objValidaCliente.idPuntoVenta = objStore.F_IdFidelizacion__c;
        }


        SrvIntClienteTransaccion_in.DT_ValidarResponse objResponse =
                logicaServiciosCliente_cls.validarCliente(objValidaCliente);

        System.assert(objResponse.validaClienteRes.mensajePer.contains
                (Label.Fielo_PuntoDeVentaNoAcumula), objResponse.validaClienteRes.mensajePer);
        objStore.F_Acumula__c = true;
        objStore.F_ClubTerpel__c = true;
        update objStore;
        objEst.F_Acumula__c = true;
        objEst.F_ClubTerpel__c = true;
        update objEst;
        objValidaCliente.tipoDocumento.valNumeroIdentificacion = idReqNumber;
        objResponse =
                logicaServiciosCliente_cls.validarCliente(objValidaCliente);

        System.assert(objResponse.validaClienteRes.mensajePer.contains(errorNotFound), objResponse.validaClienteRes.mensajePer);
        System.assert(!objResponse.validaClienteRes.confirm);

        FieloPLT__Member__c objMember = Ter_DataGenerator_cls.generateMember
                (lifeMilesNumber, idNumber, cardNumber, statusMember);
        System.debug('objMember F_NumeroLifeMiles__c -->' + objMember.F_NumeroLifeMiles__c);


        FieloPLT__Program__c program = Ter_DataGenerator_cls.generateProgramFielo();

        insert  program;

        objMember.FieloPLT__Program__c = program.Id;

        Contact contact = Ter_DataGenerator_cls.generateContact ();

        contact.AccountId = account.Id;

        insert contact;

        objMember.FieloPLT__Contact__c = contact.Id;
        objMember.FieloPLT__Status__c = statusMember;
        insert objMember;


        objValidaCliente.tipoDocumento.valNumeroIdentificacion = idReqNumber;
        objResponse =
                logicaServiciosCliente_cls.validarCliente(objValidaCliente);
        delete objStore;
        delete objEst;
        return objResponse;
    }
}