/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Trigger para el objeto de Casos
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    06/07/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
trigger Ter_Case_tgr on Case (before insert, before update) {
	
	Ter_Case_cls objCase = new Ter_Case_cls();
	
	if(Trigger.isBefore){
		if(Trigger.isInsert){
			objCase.asignarTarjetaACaso(Trigger.new, null); 
		}
		
		if(Trigger.isUpdate){
			objCase.asignarTarjetaACaso(Trigger.new, Trigger.old); 
		}
	}
    
}