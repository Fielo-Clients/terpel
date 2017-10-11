var resultWrapper;
var numFacturaPersistente = "";
var valorMilla = "";

const FIDELIZAR_BTN = 0;
const SI_BTN = 1;
const NO_BTN = 2;

function logout() {
    window.location = "/secur/logout.jsp";
    logoutActionF();
}

function formatAMPM(date) {
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var ampm = hours >= 12 ? 'pm.' : 'am.';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    minutes = minutes < 10 ? '0'+minutes : minutes;
    var strTime = hours + ':' + minutes + ' ' + ampm;
    return strTime;
}

function resetDivsAndBtns(argument) {
    $( "#acumularBtn" ).removeClass("clicked");
    $( "#pagoMillasBtn" ).removeClass("clicked");
    $( "#pagoVoucherBtn" ).removeClass("clicked");

    //Acumular
    $( ".logoAlToque" ).show();
    $( "#identificarDiv" ).hide();
    $( "#acumularFacturaDiv" ).hide();
    $( "#acumularRespuestaDiv" ).hide();
    $( "#acumularFacturaBtns" ).show();

    $( "#tipoDocumento" ).prop('selectedIndex',0);
    $( "#documento" ).val("");
    $( "#numFactura" ).val("");
    $( "#memberName" ).text("");
    $( "#memberInfo" ).text("");
    $( "#codTienda" ).text("");

    //PagoConMillas
    $( "#pagoMillasDiv").hide();
    $( "#tipoDocumentoMillas" ).prop('selectedIndex',0);
    $( "#documentoMillas" ).val("");
    $( "#montoAPagar" ).val("");
    $( "#montoMillas" ).text("");
    $( "#pinMillas" ).val("");
    $( "#millasVoucherFacturaBtns" ).hide();

    //PagoConVoucher
    $( "#pagoVoucherDiv" ).hide();
    $( "#numeroVoucher" ).val("");
    $( "#montoTituloVoucher" ).text("");
    $( "#montoVoucher" ).text("");
    $( "#voucherFacturaSubTitleDiv" ).hide();
}

function cancelarBtn() {
    numFacturaPersistente = "";
    resetDivsAndBtns();
}

function showFidelizar(result) {
    showLoader(false);
    if(!result.blnError) {
        var tipoDocumento = $( "#tipoDocumento option:selected" ).text();
        $( "#tipoDocumento" ).prop('selectedIndex',0);
        $( "#documento" ).val("");
        $( "#identificarDiv" ).hide();
        $( "#acumularFacturaDiv" ).show();

        $( "#memberName" ).text(result.strNombre);
        $( "#memberInfo" ).text(tipoDocumento + " - " + result.strNumeroDocumento);
        $( "#numFactura" ).val(numFacturaPersistente);
        $( "#codTienda" ).text(result.strCodDianTienda);
    }
    else {
        numFacturaPersistente = "";
        alert(result.strErrorMessage);
        resetDivsAndBtns();
    }
}

function acumular() {
    saveNumeroFactura();
    resetDivsAndBtns();
    $( ".logoAlToque" ).hide();
    $( "#identificarDiv" ).show();
    $( "#acumularBtn" ).addClass("clicked");
}

function showResultado(result, btnId) {
    showLoader(false);
    if(!result.blnError) {
        if(btnId == FIDELIZAR_BTN) {
            numFacturaPersistente = "";
        
            $( "#numFactura" ).val("");
            $( "#memberName" ).text("");
            $( "#memberInfo" ).text("");
            $( "#codTienda" ).text("");

            $( "#acumularFacturaDiv" ).hide();
            $( "#acumularRespuestaDiv" ).show();

            $( "#memberNameResultado" ).text(result.strNombre);
            $( "#memberTiendaFactura" ).text(result.strCodDianTienda + " - " + result.strNumeroFactura);
            $( "#memberMessage" ).text(result.strMessage);
        }
        else if(btnId == SI_BTN) {
            alert(result.strMessage);
            acumular();
        }
        else if(btnId == NO_BTN) {
            alert(result.strMessage);
            cancelarBtn();
        }
    }
    else {
        alert(result.strErrorMessage);
        resetDivsAndBtns();
    }
}

function pagoMillas() {
    resetDivsAndBtns();
    $( ".logoAlToque" ).hide();
    $( "#pagoMillasDiv" ).show();
    $( "#pagoMillasBtn" ).addClass("clicked");

    $("#montoAPagar").bind("keyup",function(e){
        var value = this.value;
        $("#montoMillas").text(Math.ceil(value/valorMilla));
    });
}

function continuarMillas() {
    showLoader(false);
    if(!resultWrapper.blnError) {
        console.log("Objeto de resultado millas: ");
        console.log(resultWrapper);
        $("#montoAPagar").unbind("keyup");
        var tipoDocumento = $( "#tipoDocumentoMillas option:selected" ).text();
        $( "#tipoDocumentoMillas" ).prop('selectedIndex',0);
        $( "#documentoMillas" ).val("");
        $( "#pagoMillasDiv" ).hide();
        $( "#acumularFacturaDiv" ).show();

        $( "#acumularFacturaBtns" ).hide();
        $( "#millasVoucherFacturaBtns" ).show();

        //Temporal
        $( "#memberName" ).text(resultWrapper.strMessage);
        $( "#memberInfo" ).text("Código de aprobación - "+resultWrapper.strCodigoAutorizacon);
        $( "#codTienda" ).text(resultWrapper.strCodDianTienda);
    }
    else {
        console.log(resultWrapper.strErrorMessage);
        alert(resultWrapper.strErrorMessage);
        resetDivsAndBtns();
    }
}



function pagoVoucher() {
    resetDivsAndBtns();
    $( ".logoAlToque" ).hide();
    $( "#pagoVoucherDiv" ).show();
    $( "#pagoVoucherBtn" ).addClass("clicked");
}

function continuarVoucher() {
    showLoader(false);
    if(!resultWrapper.blnError) {
        $( "#pagoVoucherDiv" ).hide();
        $( "#acumularFacturaBtns" ).hide();

        $( "#acumularFacturaDiv" ).show();
        $( "#voucherFacturaSubTitleDiv" ).show();
        $( "#millasVoucherFacturaBtns" ).show();

        //Temporal
        $( "#memberName" ).text(resultWrapper.strMessage.toUpperCase());
        $( "#memberInfo" ).text("Número del voucher "+resultWrapper.strVoucherNum);
        $( "#montoTituloVoucher" ).text("MONTO");
        $( "#montoVoucher" ).text("COP $"+!resultWrapper.decMontoNum?"":resultWrapper.decMontoNum);
        $( "#codTienda" ).text(resultWrapper.strCodDianTienda);
    }
    else
    {
        alert(resultWrapper.strErrorMessage);
        resetDivsAndBtns();
    }
}

function saveNumeroFactura() {
    numFacturaPersistente = $("#numFactura").val();
}

function showLoader(show) {
    if(show) {
        $( "#identificarDiv" ).hide();
        $( "#acumularFacturaDiv" ).hide();
        $( "#acumularRespuestaDiv" ).hide();

        $( "#pagoMillasDiv").hide();
        $( "#pagoVoucherDiv" ).hide();

        $( "#continuarBtn" ).prop('disabled', true);
        $( ".loader" ).show();
    }
    else {
        $( ".loader" ).hide();
        $( "#continuarBtn" ).prop('disabled', false);
    }
}
