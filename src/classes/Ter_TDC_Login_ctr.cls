/***************************************************************************************************************
* Avanxo 
* @author           Julio Cesar Galeano
* Proyecto:         TDC/Terpel
* Descripción:      Clase que contiene la logica especifica para el inicio de sesión de los usuarios de comunidades.
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    23/08/2017      Julio Cesar Galeano G               Creación de la clase
****************************************************************************************************************/

global with sharing class Ter_TDC_Login_ctr {
    global String username{get;set;}
    global String password{get;set;}

    global PageReference forwardToCustomAuthPage() {
        return new PageReference( '/Ter_TDC_Login_pag');
    }

    global PageReference login() {
        String startUrl = '/apex/Ter_TDC_Home_pag';
        PageReference ref = Site.login(username, password, startUrl);
        system.debug('=============================LOGIN PORTAL TERPEL===========================');
        system.debug(ref);
        system.debug('===========================================================================');
        return ref;
    }

    global PageReference logout() {
        return new PageReference('/secur/logout.jsp');
    }
}