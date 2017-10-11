/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase con la logica a aplicar en el Trigger de Casos
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    06/07/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class Ter_Case_cls {

	/* 
	* Nombre: asignarTarjetaACaso
    * Descripcion: Metodo encargado obtener una Tarjeta Pre-Inscrita inactiva de forma aleatoria y asignarla a un caso
    * Fecha Creación: 06/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            06-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
    public void asignarTarjetaACaso(list<Case> lstCasosNew, list<Case> lstCasosOld){
        list<FieloPLT__Member__c> lstMember;
        Integer intCount;
        Integer intRand;
        
        if((lstCasosNew.get(0).F_AsignarTarjetaPreinscrita__c && lstCasosOld == null) ||
            (lstCasosOld != null && lstCasosNew.get(0).F_AsignarTarjetaPreinscrita__c != lstCasosOld.get(0).F_AsignarTarjetaPreinscrita__c 
             && lstCasosNew.get(0).F_AsignarTarjetaPreinscrita__c && lstCasosNew.get(0).F_TarjetaPreinscrita__c == null)){

        
	        intCount = [SELECT COUNT() FROM FieloPLT__Member__c 
	                    WHERE RecordType.DeveloperName = :label.Ter_lbl_RT_TarjetaPreinscrita 
	                          AND F_EstadoTarjetaPreinscrita__c = 'Inactiva' 
	                          AND F_TipoTarjetaPreinscrita__c = 'Virtual'];
	        intRand = Math.floor(Math.random() * intCount).intValue();
	        lstMember = [SELECT Id, Name, F_EstadoTarjetaPreinscrita__c FROM FieloPLT__Member__c 
	        			 WHERE RecordType.DeveloperName = :label.Ter_lbl_RT_TarjetaPreinscrita 
	                          AND F_EstadoTarjetaPreinscrita__c = 'Inactiva' 
	                          AND F_TipoTarjetaPreinscrita__c = 'Virtual'
	                          LIMIT 1 OFFSET :intRand];
	        system.debug('----------> intRand: ' + intRand + ' Tarjeta ' + lstMember);
	        if(lstMember.isEmpty()){
	            lstCasosNew.get(0).addError('No se encontraron tarjetas pre-inscritas disponibles para asignar.');
	            return;
	        }
	        
	        lstCasosNew.get(0).F_TarjetaPreinscrita__c = lstMember.get(0).Id;
	        
	        lstMember.get(0).F_EstadoTarjetaPreinscrita__c = 'Asignada';
	        update lstMember;
        } else{
        	String strOutput = '';
			strOutput += '\n[NEW] F_AsignarTarjetaPreinscrita__c: ' + lstCasosNew.get(0).F_AsignarTarjetaPreinscrita__c;
			if(lstCasosOld != null)
				strOutput += '\n[OLD] F_AsignarTarjetaPreinscrita__c: ' + lstCasosOld.get(0).F_AsignarTarjetaPreinscrita__c;
			else
				strOutput += '\n[OLD] Esta vacio';
			strOutput += '\n[NEW] F_TarjetaPreinscrita__c: ' + lstCasosNew.get(0).F_TarjetaPreinscrita__c;
			system.debug('----------> Se vino por el ELSE' + strOutput);
        }
    }
    
}