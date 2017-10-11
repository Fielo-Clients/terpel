/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 21/06/2017
* 
* Name: Fielo_BAT_SCH_MemberExpiracionTarjeta.cls
* 
* Scheduler para expirar as tarjetas prescritas
*******************************************************************************/
global class Fielo_BAT_SCH_MemberExpiracionTarjeta implements Schedulable, Database.StateFul, Database.Batchable<sObject>{

  // Rectypes of member
  public final static String CLIENTE_PREINSCRITA_ID = RecType.getID('FieloPLT__Member__c', 'Tarjeta Preinscrita');

	// Status Member	
	public final static String BLOQUEADO = 'Bloqueado';

	/* Fielo_BAT_SCH_MemberExpiracionTarjeta sb = new Fielo_BAT_SCH_MemberExpiracionTarjeta();
	String sch = '0 1 0 * * ? * ';
	String jobID = system.schedule('Expiracion Tarjetas', sch, sb);*/

	global void execute(SchedulableContext sc) {
		Fielo_BAT_SCH_MemberExpiracionTarjeta bVC = new Fielo_BAT_SCH_MemberExpiracionTarjeta(); 
        Database.ExecuteBatch(bVC); 
	}

	global Database.QueryLocator start(Database.BatchableContext BC){

        String lQuery = ' SELECT FieloPLT__User__c, F_EstadoTarjetaPreinscrita__c, FieloPLT__Status__c '
        				+ ' FROM FieloPLT__Member__c  WHERE F_EstadoTarjetaPreinscrita__c IN (\'Activa\',\'Asignada\') '
        				+ ' AND F_FechaExpiracionTarjeta__c <= ' + DateTime.now().format('yyyy-MM-dd')
                + ' AND RecordTypeId = \'' + CLIENTE_PREINSCRITA_ID + '\'';
                
        return Database.getQueryLocator(lQuery);     
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){

		if ( scope == null || scope.isEmpty() ) return; 

		List<FieloPLT__Member__c> lMemberLst = ( List<FieloPLT__Member__c> ) scope;  

		for(FieloPLT__Member__c mb :lMemberLst) {

			mb.FieloPLT__Status__c = BLOQUEADO;
			mb.F_EstadoTarjetaPreinscrita__c = 'Expirada';
		}
		
		Database.update(lMemberLst,false); 		                          
    }

   global void finish(Database.BatchableContext BC){	
   	
   }

   //botão da visualforce
   webService static Boolean expiracionTarjetaMember() {
    	
    	Fielo_BAT_SCH_MemberExpiracionTarjeta bVC = new Fielo_BAT_SCH_MemberExpiracionTarjeta(); 
        Database.ExecuteBatch(bVC); 
     
        return true;
   } 
}