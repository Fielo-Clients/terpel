public class Ter_Task_cls {

    public List<Profile> lstProfiles =  new List<Profile>();

    public Ter_Task_cls()
    {
        lstProfiles = [select name from Profile where id =: UserInfo.getProfileId()];

    }

    public void permisoModificar (List<Task> lstNewTask)
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
                 objPerfil.Name != Label.Ter_PermisoBMPerfilAdministradorSistema &&
                 objPerfil.Name != Label.Ter_PermisoBMPerfilJefe_de_Zona_EDS_Combustibles)
            {
               lstNewTask[0].subject.addError('Según su perfil no cuenta con permisos para Modificacion');
            }
        }

    
    }

    public void permisoBorrar (List<Task> lstOldTask)
    {

        for(Profile objPerfil : lstProfiles)
        {
            if(objPerfil.Name != label.Ter_PermisoBMPerfilAdministradorSistema && 
               objPerfil.Name != label.Ter_PermisoBMAdministrador_Funcional_Plataforma &&
               objPerfil.Name != label.Ter_PermisoBMPerfilAdministradorFuncionalComercial
               )
            {
               lstOldTask[0].subject.addError('Según su perfil no cuenta con permisos para Borrado');
            }
        }
        

    }

}