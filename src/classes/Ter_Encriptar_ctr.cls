public with sharing class Ter_Encriptar_ctr{

    private Ter_UtilEncriptacion_cls objUtilEncriptacion;
    
    public String strFfn {get; set;}
    public String strFname {get; set;}
    public String strSname {get; set;}
    public String strPlname {get; set;}
    public String strSlname {get; set;}
    public String strBirdt {get; set;}
    public String strEmail {get; set;}
    public String strPhone {get; set;}
    public String strGend {get; set;}
    public String strPostcod {get; set;}
    public String strTdoc {get; set;}
    public String strCtrdoc {get; set;}
    public String strNdoc {get; set;}
    public String strLang {get; set;}
    public String strAddrc {get; set;}
    public String strCtrc {get; set;}
    public String strStc {get; set;}
    public String strCityc {get; set;}
    public String strTyctp {get; set;}
    public String strDtyctp {get; set;}
    public String strSession {get; set;}
    public String strBln {get; set;}
    public String strCderror {get; set;}
    
    public String strFfnEncr {get; set;}
    public String strFnameEncr {get; set;}
    public String strSnameEncr {get; set;}
    public String strPlnameEncr {get; set;}
    public String strSlnameEncr {get; set;}
    public String strBirdtEncr {get; set;}
    public String strEmailEncr {get; set;}
    public String strPhoneEncr {get; set;}
    public String strGendEncr {get; set;}
    public String strPostcodEncr {get; set;}
    public String strTdocEncr {get; set;}
    public String strCtrdocEncr {get; set;}
    public String strNdocEncr {get; set;}
    public String strLangEncr {get; set;}
    public String strAddrcEncr {get; set;}
    public String strCtrcEncr {get; set;}
    public String strStcEncr {get; set;}
    public String strCitycEncr {get; set;}
    public String strTyctpEncr {get; set;}
    public String strDtyctpEncr {get; set;}
    public String strSessionEncr {get; set;}
    public String strBlnEncr {get; set;}
    public String strCderrorEncr {get; set;}
    
    public String strURLGenerada {get; set;}
    public String strDireccionIp {get; set;}
    
    public String strDatoLimpioTerpel {get; set;}
    public String strDatoEncriptadoTerpel {get; set;}
    public String strDatoEncrLM {get; set;}
    public String strDatoLimpioLM {get; set;}
    
    public Ter_Encriptar_ctr(){
        objUtilEncriptacion = new Ter_UtilEncriptacion_cls();
        strFfn = '';
        strFname = '';
        strSname = '';
        strPlname = '';
        strSlname = '';
        strBirdt = '';
        strEmail = '';
        strPhone = '';
        strGend = '';
        strPostcod = '';
        strTdoc = '';
        strCtrdoc = '';
        strNdoc = '';
        strLang = '';
        strAddrc = '';
        strCtrc = '';
        strStc = '';
        strCityc = '';
        strTyctp = '';
        strDtyctp = '';
        strSession = '';
        strBln = '';
        strCderror = '';
        
        strDireccionIp = '';
    }
    
    public pageReference encriptar(){
        system.debug('=====>>>> va a encriptar......');
        strURLGenerada = '';
        if(!String.isEmpty(strFfn)){
            strFfnEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strFfn));
            strURLGenerada += '?FFN=' + strFfnEncr;
        }

        if(!String.isEmpty(strFname)){
            strFnameEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strFname));
            strURLGenerada += '&FNAME=' + strFnameEncr;
        }

        if(!String.isEmpty(strSname)){
            strSnameEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strSname));
            strURLGenerada += '&SNAME=' + strSnameEncr;
        }

        if(!String.isEmpty(strPlname)){
            strPlnameEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strPlname));
            strURLGenerada += '&PLNAME=' + strPlnameEncr;
        }

        if(!String.isEmpty(strSlname)){
            strSlnameEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strSlname));
            strURLGenerada += '&SLNAME=' + strSlnameEncr;
        }

        if(!String.isEmpty(strBirdt)){
            strBirdtEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strBirdt));
            strURLGenerada += '&BIRDT=' + strBirdtEncr;
        }

        if(!String.isEmpty(strEmail)){
            strEmailEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strEmail));
            strURLGenerada += '&EMAIL=' + strEmailEncr;
        }

        if(!String.isEmpty(strPhone)){
            strPhoneEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strPhone));
            strURLGenerada += '&PHONE=' + strPhoneEncr;
        }

        if(!String.isEmpty(strGend)){
            strGendEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strGend));
            strURLGenerada += '&GEND=' + strGendEncr;
        }

        if(!String.isEmpty(strPostcod)){
            strPostcodEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strPostcod));
            strURLGenerada += '&POSTCOD=' + strPostcodEncr;
        }

        if(!String.isEmpty(strTdoc)){
            strTdocEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strTdoc));
            strURLGenerada += '&TDOC=' + strTdocEncr;
        }

        if(!String.isEmpty(strCtrdoc)){
            strCtrdocEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strCtrdoc));
            strURLGenerada += '&CTRDOC=' + strCtrdocEncr;
        }

        if(!String.isEmpty(strNdoc)){
            strNdocEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strNdoc));
            strURLGenerada += '&NDOC=' + strNdocEncr;
        }

        if(!String.isEmpty(strLang)){
            strLangEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strLang));
            strURLGenerada += '&LANG=' + strLangEncr;
        }

        if(!String.isEmpty(strAddrc)){
            strAddrcEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strAddrc));
            strURLGenerada += '&ADDRC=' + strAddrcEncr;
        }

        if(!String.isEmpty(strCtrc)){
            strCtrcEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strCtrc));
            strURLGenerada += '&CTRC=' + strCtrcEncr;
        }

        if(!String.isEmpty(strStc)){
            strStcEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strStc));
            strURLGenerada += '&STC=' + strStcEncr;
        }

        if(!String.isEmpty(strCityc)){
            strCitycEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strCityc));
            strURLGenerada += '&CITYC=' + strCitycEncr;
        }

        if(!String.isEmpty(strTyctp)){
            strTyctpEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strTyctp));
            strURLGenerada += '&TYCTP=' + strTyctpEncr;
        }

        if(!String.isEmpty(strDtyctp)){
            strDtyctpEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strDtyctp));
            strURLGenerada += '&DTYCTP=' + strDtyctpEncr;
        }

        if(!String.isEmpty(strSession)){
            strSessionEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strSession));
            strURLGenerada += '&SESSION=' + strSessionEncr;
        }

        if(!String.isEmpty(strBln)){
            strBlnEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strBln));
            strURLGenerada += '&BLN=' + strBlnEncr;
        }

        if(!String.isEmpty(strCderror)){
            strCderrorEncr = Ter_UtilEncriptacion_cls.cifradoURL3D(objUtilEncriptacion.encriptarAES256LifeMiles_B64(strCderror));
            strURLGenerada += '&CDERROR=' + strCderrorEncr;
        }


        return null;
    }
    
    public void obtenerIp(){
        try{
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://icanhazip.com/');
            req.setMethod('GET');
            Http httpReq = new Http();
            HttpResponse res = httpReq.send(req);
            System.debug(res.getBody());
            strDireccionIp = res.getBody();
        }catch(Exception e){
            strDireccionIp = 'Error: ' + e.getMessage();
        }
    }
    
    public void encriptarTerpel(){
        if(!String.isEmpty(strDatoLimpioTerpel)){
            strDatoEncriptadoTerpel = objUtilEncriptacion.encriptarAES256Terpel_B64(strDatoLimpioTerpel);
        }
    }
    
    public void desencriptarTerpel(){
        if(!String.isEmpty(strDatoLimpioTerpel)){
            strDatoEncriptadoTerpel = objUtilEncriptacion.desencriptarAES256Terpel_B64(strDatoLimpioTerpel);
        }
    }
    
    public void desencriptarLM(){
        if(!String.isEmpty(strDatoEncrLM)){
            strDatoLimpioLM = objUtilEncriptacion.desencriptarAES256LifeMiles_B64(strDatoEncrLM);
        }
    }
}