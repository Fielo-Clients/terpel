/***************************************************************************************************************
* Avanxo 
* @author           Julio Cesar Galeano
* Proyecto:         TDC/Terpel
* Descripción:      Clase que contiene la logica especifica de la pantalla principal para las Tiendas de 
*                   conveniencia.
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    23/08/2017      Julio Cesar Galeano G               Creación de la clase
****************************************************************************************************************/
global with sharing class Ter_TDC_Home_Ctr {

    public static String TRANSACCION_ACUMULACION = 'Acumulacion';
    public static String TRANSACCION_PAGO_MILLAS = 'PagoMillas';
    public static String TRANSACCION_PAGO_VOUCHER = 'PagoVoucher';

    global PageReference logout() {
        return new PageReference('/secur/logout.jsp');
    }

    
    @RemoteAction
    public static TDC_Wrapper validarCliente(string strTipoDocumento, string strNumeroDocumento) {
        Ter_LogicaServiciosGeneral_cls objLogicaServiciosGeneral = new Ter_LogicaServiciosGeneral_cls();
        TDC_Wrapper objWrapper = new TDC_Wrapper();
        objWrapper.userId = UserInfo.getUserId();

        Boolean blnError;
        String strError;

        try {
            FieloPLT__Member__c objMember = objLogicaServiciosGeneral.obtenerMember(strTipoDocumento, strNumeroDocumento);
            system.debug('DEBUG-FIDELIZARVENTA: Member: ' + objMember);
            objWrapper.strNombre = getMemberNombre(objMember, strTipoDocumento);

            string strNumIdentificacion = '';
            if(strTipoDocumento=='NLM')
                strNumIdentificacion = objMember.F_NumeroLifeMiles__c;
            else if(strTipoDocumento=='TPI')
                strNumIdentificacion = objMember.F_NumeroTarjetaPreinscrita__c;
            else
                strNumIdentificacion = objMember.F_IdentificationNumber__c;

            objWrapper.strNumeroDocumento = strNumIdentificacion;
            objWrapper.idMemberId = objMember.Id;
            objWrapper.idFieloPLTAccount = objMember.FieloPLT__Account__c;
            objWrapper.strTipoTransaccion = TRANSACCION_ACUMULACION;

            Ter_POS__c objTienda = getCodigoDianTiendaPOS();
            objWrapper.strErrorMessage = validarNegocioComplementario(objTienda);

            if(!String.isBlank(objWrapper.strErrorMessage)) {
                objWrapper.blnError = true;
            }
            else {
                objWrapper.strCodDianTienda = getCodigoDianTiendaPOS().Ter_Codigo_DIAN__c;
                objWrapper.blnError = false;
            }
        } catch (Ter_ValidationException e) {
            objWrapper.blnError = true;
            objWrapper.strErrorMessage = e.getMessage();
        }
        catch (NullPointerException e) {
            objWrapper.blnError = true;
            objWrapper.strErrorMessage = 'No se ha relacionado el usuario con una tienda de conveniencia o no tiene asignado un código DIAN';
        }
        return objWrapper;
    }

    @RemoteAction 
    public static TDC_Wrapper guardarVenta(TDC_Wrapper objWrapper) {

        if(objWrapper.strTipoTransaccion == TRANSACCION_ACUMULACION) {
            return fidelizarVenta(objWrapper);
        }
        else if(objWrapper.strTipoTransaccion == TRANSACCION_PAGO_MILLAS) {
            return actualizarVentaMillasYVoucher(objWrapper);
        }
        else if(objWrapper.strTipoTransaccion == TRANSACCION_PAGO_VOUCHER) {
            return verificarVentaVoucher(objWrapper);
        }
        return null;
    }

    private static TDC_Wrapper fidelizarVenta(TDC_Wrapper objWrapper) {
        system.debug('DEBUG-FIDELIZARVENTA: '+ objWrapper);

        try {
            Ter_Venta_TDC__c objVenta = new Ter_Venta_TDC__c();
            objVenta.Ter_TipoTransaccion__c = 'Acumulación';
            objVenta.Ter_OrigenVenta__c = 'Tienda';
            objVenta.Ter_Tienda__c = getCodigoDianTiendaPOS().Ter_Negocio_Complementario__c;
            objVenta.Ter_Cliente__c = objWrapper.idFieloPLTAccount;
            objVenta.Ter_Member__c = objWrapper.idMemberId;
            objVenta.Ter_IdVenta__c = objWrapper.strCodDianTienda + objWrapper.strNumeroFactura;
            objVenta.Ter_Estado__c = 'Pendiente';
            objVenta.Ter_TipoVenta__c = 'Tiendas';
            insert objVenta;

            objWrapper.blnError = false;
            objWrapper.strMessage = 'Su venta ha sido fidelizada exitosamente.';
            system.debug('DEBUG-FIDELIZARVENTA: '+ objWrapper.strMessage);
        }
        catch(DmlException e) {
            System.Debug('====================== EXCEPCION FIDELIZARVENTA ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('====================================================================');

            objWrapper.blnError = true;
            objWrapper.strErrorMessage = 'Hubo un problema con la creación de la venta.';
            system.debug('DEBUG-FIDELIZARVENTA: '+ objWrapper.strErrorMessage);
        }
        catch (NullPointerException e) {
            objWrapper.blnError = true;
            objWrapper.strErrorMessage = 'No se ha relacionado el usuario con una tienda de conveniencia';
        }
        return objWrapper;
    }

    private static string getMemberNombre(FieloPLT__Member__c objMember, string strTipoDocumento) {
        String strNombre = '';
        if (Label.TER_NUMERO_LIFE_MILES_TYPE.equals(strTipoDocumento)) {
            strNombre = objMember.F_NumeroLifeMiles__c;
        } 
        else if (Label.TER_TARJETA_PREINSCRITA_TYPE.equals(strTipoDocumento)) {
            strNombre = objMember.F_NumeroTarjetaPreinscrita__c;
        } 
        else{
            strNombre = (String.isEmpty(objMember.F_PrimerNombre__c) ? '' : objMember.F_PrimerNombre__c + ' ') 
            + (String.isEmpty(objMember.F_SegundoNombre__c) ? '' : objMember.F_SegundoNombre__c + ' ' ) 
            + (String.isEmpty(objMember.F_PrimerApellido__c) ? '' : objMember.F_PrimerApellido__c + ' ')  
            + (String.isEmpty(objMember.F_SegundoApellido__c) ? '' : objMember.F_SegundoApellido__c);
        }
        return strNombre;
    }

    private static string validarNegocioComplementario(Ter_POS__c objTienda) {
        if(objTienda==null) {
            return 'No se ha relacionado el usuario con una tienda de conveniencia';
        }

        SObject puntoVenta = null;
        puntoVenta = new Ter_LogicaServiciosGeneral_cls().consultarTTCC(objTienda.Ter_Negocio_Complementario__r.F_IdFidelizacion__c);

        if ( puntoVenta != null && (!((Ter_Negocio_Complementario__c) puntoVenta).F_Acumula__c
        || !((Ter_Negocio_Complementario__c) puntoVenta).F_ClubTerpel__c)) {
            return 'La tienda de conveniencia no esta habilitada para acumular';
        }
        return '';
    }

    private static Ter_POS__c getCodigoDianTiendaPOS() {
        List<Ter_POS__c> lstTiendas = [ SELECT Id, Name, Ter_Codigo_DIAN__c, Ter_Negocio_Complementario__c, Ter_Negocio_Complementario__r.F_IdFidelizacion__c,
                                                            Ter_Negocio_Complementario__r.Name FROM Ter_POS__c WHERE Ter_Usuario__c = :UserInfo.getUserId() ];
        if(!lstTiendas.isEmpty())
            return lstTiendas.get(0);
        else
            return null;
    }

    @RemoteAction
    public static TDC_InitDataWrapper getInitData() {
        Ter_POS__c objTienda = getCodigoDianTiendaPOS();
        TDC_InitDataWrapper objInitDataWrapper = new TDC_InitDataWrapper();
        if(objTienda!=null) {
            objInitDataWrapper.strNombreTienda = objTienda.Name;
            Decimal decValorMilla = getValorMilla();
            if(decValorMilla==-1) {
                objInitDataWrapper.strNombreTienda = 'ERROR: No se ha definido el valor de la milla.';
                return objInitDataWrapper;
            }
            objInitDataWrapper.decValorMilla = decValorMilla;
            return objInitDataWrapper;
        }
        else {
            objInitDataWrapper.strNombreTienda = 'ERROR: No se ha relacionado el usuario con una tienda de conveniencia';
            return objInitDataWrapper;
        }
    }

    private static Decimal getValorMilla() {
        List<Ter_TDC_Valor_Milla__c> lstValorMilla = Ter_TDC_Valor_Milla__c.getall().values();
        if(lstValorMilla.size()>0) {
            return lstValorMilla[0].Ter_TDC_Valor_Milla__c;
        }
        return -1;
    }

    @RemoteAction
    public static TDC_Wrapper validarVoucher(string strVoucherNum) {
        SrvIntClienteTransaccion_in.DT_ValidaVoucherClienteEntrada objValidaVoucherClienteEntrada;
        SrvIntClienteTransaccion_in.DT_ValidaVoucherClienteSalida objValidaVoucherClienteSalida;
        Ter_POS__c objTienda = getCodigoDianTiendaPOS();
        TDC_Wrapper objWrapper = new TDC_Wrapper();
        objWrapper.strCodDianTienda = objTienda.Ter_Codigo_DIAN__c;
        objWrapper.strVoucherNum = strVoucherNum;
        objWrapper.strTipoTransaccion = TRANSACCION_PAGO_VOUCHER;

        objValidaVoucherClienteEntrada = new SrvIntClienteTransaccion_in.DT_ValidaVoucherClienteEntrada();
        objValidaVoucherClienteEntrada.origenVenta = 'TDC';
        objValidaVoucherClienteEntrada.idPuntoVenta = objTienda.Ter_Negocio_Complementario__r.F_IdFidelizacion__c;//IdFidelizacion de la Tienda
        objValidaVoucherClienteEntrada.codVoucher = objWrapper.strVoucherNum;//Codigo de Voucher a validar

        Ter_LogicaServiciosCore_cls objLogicaServiciosCore = new Ter_LogicaServiciosCore_cls();
        objValidaVoucherClienteSalida = objLogicaServiciosCore.validarVoucherSync(objValidaVoucherClienteEntrada);
        System.debug('========================= OBJETO DE SALIDA VALIDAR VOUCHER ==============================');
        System.debug(objValidaVoucherClienteSalida);
        System.debug('=========================================================================================');

        if(!objValidaVoucherClienteSalida.contextoRespuestaTipo.codEstadoTx.equals(label.Ter_lbl_codEstadoTx_Ok)) {
            if(!objValidaVoucherClienteSalida.falloTipo.errores.isEmpty()){
                objWrapper.strErrorMessage = '';
                objWrapper.blnError = true;
                for(SrvIntClienteTransaccion_in.DT_ErrorTipo objErrorTipo : objValidaVoucherClienteSalida.falloTipo.errores) {
                    if(!String.isBlank(objWrapper.strErrorMessage))
                        objWrapper.strErrorMessage += ', ';    
                    objWrapper.strErrorMessage += objErrorTipo.valDescError;
                }
            }
        } 
        else {
            //Voucher es OK
            objWrapper.decMontoNum = objValidaVoucherClienteSalida.monto;
            objWrapper.blnError = false;
            objWrapper.strMessage = objValidaVoucherClienteSalida.mensajePer;
        }
        return objWrapper;
    }

    @RemoteAction
    public static TDC_Wrapper validarMillas(string strMontoAPagar, string strMontoMillas, string strTipoDocumento, string strNumeroDocumento, string strPinMillas) {
        TDC_Wrapper objWrapper = validarCliente(strTipoDocumento, strNumeroDocumento);
        objWrapper.strTipoTransaccion = TRANSACCION_PAGO_MILLAS;
        if(objWrapper.blnError)
            return objWrapper;

        try {
            Ter_LogicaAlternativaTDC_cls objLogicaAlternativaTDC = new Ter_LogicaAlternativaTDC_cls();
            Ter_LogicaAlternativaTDC_cls.RespuestaRedencionWrapper objRespuestaRedencionWrapper = 
                objLogicaAlternativaTDC.procesarRedencionTDC(objWrapper.idMemberId, Decimal.valueOf(strMontoMillas), getCodigoDianTiendaPOS().Ter_Negocio_Complementario__c, objWrapper.strCodDianTienda, strPinMillas);
            objWrapper.blnError = !objRespuestaRedencionWrapper.blnEstadoTransaccion;
            if(objWrapper.blnError) {
                objWrapper.strErrorMessage = objRespuestaRedencionWrapper.strMensajeRespuesta;
            }
            else {
                objWrapper.strIdVentaGenerado = objRespuestaRedencionWrapper.idVentaGenerado;
                objWrapper.strCodigoAutorizacon = objRespuestaRedencionWrapper.strCodigoAutorizacon;
                objWrapper.strMessage = objRespuestaRedencionWrapper.strMensajeRespuesta;
            }
            return objWrapper;
        }
        catch(Exception e) {
            objWrapper.blnError = true;
            objWrapper.strErrorMessage = e.getMessage();
        }
        return objWrapper;
    }

    private static TDC_Wrapper actualizarVentaMillasYVoucher(TDC_Wrapper objWrapper) {
        try {
            Fielo_Venta__c objVenta = [SELECT F_IdVenta__c FROM Fielo_Venta__c WHERE F_IdVenta__c = :objWrapper.strIdVentaGenerado];
            objVenta.F_IdVenta__c = objWrapper.strNumeroFactura;
            update objVenta;
            objWrapper.blnError = false;
            objWrapper.strMessage = 'Venta guardada con exito';
        }
        catch(DmlException e) {
            System.Debug('====================== EXCEPCION FIDELIZARVENTA ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('====================================================================');

            objWrapper.blnError = true;
            objWrapper.strErrorMessage = 'Hubo un problema con la actualización de la venta.';
        }
        return objWrapper;
    }

    private static TDC_Wrapper verificarVentaVoucher(TDC_Wrapper objWrapper) {
        try {

            Ter_LogicaAlternativaTDC_cls.RespuestaReclamacionWrapper objRespuestaReclamacionWrapper = 
                (new Ter_LogicaAlternativaTDC_cls()).procesarReclamacionTDC(objWrapper.strNumeroFactura, objWrapper.decMontoNum, getCodigoDianTiendaPOS().Ter_Negocio_Complementario__c, 
                    objWrapper.strCodDianTienda, objWrapper.strVoucherNum);

            if(!objRespuestaReclamacionWrapper.blnEstadoTransaccion) {
                objWrapper.blnError = true;
                objWrapper.strErrorMessage = objRespuestaReclamacionWrapper.strMensajeRespuesta;
                return objWrapper;
            }
        }
        catch(DmlException e) {
            System.Debug('====================== EXCEPCION FIDELIZARVENTA ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('====================================================================');

            objWrapper.blnError = true;
            objWrapper.strErrorMessage = 'Hubo un problema con la actualización de la venta.';
        }
        return objWrapper;
    }


  public class TDC_Wrapper {
    public string strTipoTransaccion {get; set;}
    public string strNombre {get; set;}
    public string strCodDianTienda {get; set;}
    public string strNumeroDocumento {get; set;}
    public string strNumeroFactura {get; set;}
    public Boolean blnError {get; set;}
    public string strErrorMessage {get; set;}
    public string strMessage {get; set;}
    public string idFieloPLTAccount {get; set;}
    public string idMemberId {get; set;}
    public string userId {get; set;}
    public string strVoucherNum {get; set;}
    public Decimal decMontoNum {get; set;}
    public string strIdVentaGenerado {get; set;}
    public string strCodigoAutorizacon {get; set;}
    public Decimal decValorMilla {get; set;}
  }

  public class TDC_InitDataWrapper {
    public Decimal decValorMilla {get; set;}
    public string strNombreTienda {get; set;} 
  }
}