/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez (WRM)
Proyecto: Terpel
Descripción: Clase que se encargara delas validaciones y las creaciones sobre el objeto evento. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 20-01-2017  Walter Rodríguez M (WRM)      Creación de la Clase.
***********************************************************************************/
public class Ter_Eventos_cls 
{
    public List<Profile> lstProfiles =  new List<Profile>();

    public Ter_Eventos_cls()
    {
        lstProfiles = [select name from Profile where id =: UserInfo.getProfileId()];
    }
    
    public void crearActa(List<Event>lstNewEvent)
    {
        if(lstNewEvent[0].Ter_Tipo_Acta__c != 'No_aplica' && lstNewEvent[0].Ter_Tipo_Acta__c != null)
        {
            List<RecordType>lstRt = [SELECT Id, Name FROM RecordType WHERE Name =: lstNewEvent[0].Ter_Tipo_Acta__c limit 1];
            Ter_Acta_Encuesta__c objActa = new Ter_Acta_Encuesta__c();
            if(!lstRt.isEmpty())
            {
                objActa.RecordTypeId = lstRt[0].Id;
                if( lstNewEvent[0].Ter_Tipo_Acta__c =='Acta Bitácora Ambiental GA' || lstNewEvent[0].Ter_Tipo_Acta__c == 'Acta Seguimiento Mensual GNV')
                    objActa.Ter_Nombre_EDS__c = lstNewEvent[0].WhatId;
                else
                    objActa.Ter_nombre_de_cliente__c = lstNewEvent[0].WhatId;
                try
                {
                    insert objActa;
                    lstNewEvent[0].Ter_Acta__c = objActa.Id;
                }
                catch(system.exception e)
                {
                    system.debug('Error --> ' + e);
                    if(lstNewEvent[0].Ter_Tipo_Acta__c =='Acta Bitácora Ambiental GA' || lstNewEvent[0].Ter_Tipo_Acta__c == 'Acta Seguimiento Mensual GNV')
                        lstNewEvent[0].WhatId.addError('Error! Para este tipo de Acta se debe relacionar una EDS');
                    else
                        lstNewEvent[0].WhatId.addError('Error! Para este tipo de Acta se debe relacionar un Cliente');
                }
            }
        }

    }

    public void permisoModificar (List<Event> lstNewEvent)
    {
        
        for(Profile objPerfil : lstProfiles)
        {
            if( 
                objPerfil.Name != label.Ter_PermisoBMPerfilAdministradorFuncionalComercial &&
                objPerfil.Name != label.Ter_PermisoBMAdministrador_Funcional_Plataforma &&
                objPerfil.Name != label.Ter_PermisoBMPerfilAdministradorT_cnicoPlataforma &&
                objPerfil.Name != Label.Ter_PermisoBMPerfilSupervisor_II_Aviacion_y_Marinos && 
                objPerfil.Name != Label.Ter_PermisoBMPerfilEjecutivo_de_cuenta_Marinos &&
                objPerfil.Name != Label.Ter_PermisoBMPerfilEjecutivo_de_cuenta_Aviacion &&
                objPerfil.Name != Label.Ter_PermisoBMPerfilSupervisor_SSAC &&
                objPerfil.Name != Label.Ter_PermisoBMPerfilSupervisor_II_GNV_Conversiones &&
                objPerfil.Name != Label.Ter_PermisoBMPerfilJefe_Comercial_Conversiones &&
                objPerfil.Name != Label.Ter_PermisoBMPerfilEjecutivo_de_Cuenta_Industria &&
                objPerfil.Name != Label.Ter_PermisoBMPerfilSupervisor_II_Lubricantes &&
                objPerfil.Name != Label.Ter_PermisoBMPerfilJefe_de_Zona_Lubricantes &&
                objPerfil.Name != Label.Ter_PermisoBMPerfilGerente_Regional &&
                objPerfil.Name != Label.Ter_PermisoBMPerfilJefe_de_Zona_EDS_Combustibles &&
                objPerfil.Name != Label.Ter_PermisoBMPerfilAdministradorSistema)
            {
                lstNewEvent[0].subject.addError('Según su perfil no cuenta con permisos para Modificacion');
            }
        }
    }

    public void permisoBorrar (List<Event> lstOldEvent)
    {
        for(Profile objPerfil : lstProfiles)
        {
            if(
                objPerfil.Name != label.Ter_PermisoBMAdministrador_Funcional_Plataforma &&
                objPerfil.Name != label.Ter_PermisoBMPerfilAdministradorFuncionalComercial &&
                objPerfil.Name != label.Ter_PermisoBMPerfilAdministradorSistema)
            {
                lstOldEvent[0].subject.addError('Según su perfil no cuenta con permisos para Borrado');
            }
        }
    }
}