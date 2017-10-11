/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 22/05/2017
* 
* Name: Fielo_TRIG_MemberAfter.cls
* 
* Class for after event of Fielo Member object
*
*******************************************************************************/
public without sharing class Fielo_TRIG_MemberAfter {  

	public static boolean ISRUNNING = false;

	public static void updateAccount() {
		
		TriggerCheck.assert();

		if ( ISRUNNING ) return;        

		Map<Id,FieloPLT__Member__c> lMemberMap = (Map<Id,FieloPLT__Member__c>) trigger.newmap;
				
		Map<Id,Account> lAccMap = new Map<Id,Account>([
			SELECT F_Member__c, Ter_Tipo_de_vehiculo__c, Ter_OperadorCelular__c,
				F_TipoTarjetaPreinscrita__c, F_CodigoTarjetaPreinscrita__c,
				F_EstadoTarjetaPreinscrita__c, 
				F_FechaActivacionTarjeta__pc, F_FechaExpiracionTarjeta__pc
			FROM Account
			WHERE F_Member__c IN :lMemberMap.keySet()]);

		List<Account> lAccountLst = new List<Account>();
		for(FieloPLT__Member__c mb :lMemberMap.values()) {
			// Check changes
			Account lAccAux = lAccMap.get(mb.FieloPLT__Account__c);
			if(lAccAux != null) {
				if((lAccAux.Ter_Tipo_de_vehiculo__c != mb.F_TipoVehiculo__c) || 
					(lAccAux.Ter_OperadorCelular__c != mb.F_OperadorCelular__c) || 
					(lAccAux.F_TipoTarjetaPreinscrita__c != mb.F_TipoTarjetaPreinscrita__c) || 
					(lAccAux.F_CodigoTarjetaPreinscrita__c != mb.F_NumeroTarjetaPreinscrita__c) || 
					(lAccAux.F_EstadoTarjetaPreinscrita__c != mb.F_EstadoTarjetaPreinscrita__c) ||
					(lAccAux.F_FechaActivacionTarjeta__pc != mb.F_FechaActivacionTarjeta__c) || 
					(lAccAux.F_FechaExpiracionTarjeta__pc != mb.F_FechaExpiracionTarjeta__c)) {

					lAccountLst.add(
						new Account(

							id 								= mb.FieloPLT__Account__c,
							Ter_Tipo_de_vehiculo__c			= mb.F_TipoVehiculo__c,
							Ter_OperadorCelular__c			= mb.F_OperadorCelular__c,
							F_TipoTarjetaPreinscrita__c		= mb.F_TipoTarjetaPreinscrita__c,
							F_CodigoTarjetaPreinscrita__c	= mb.F_NumeroTarjetaPreinscrita__c,
							F_EstadoTarjetaPreinscrita__c	= mb.F_EstadoTarjetaPreinscrita__c,
							F_FechaActivacionTarjeta__pc	= mb.F_FechaActivacionTarjeta__c,
							F_FechaExpiracionTarjeta__pc	= mb.F_FechaExpiracionTarjeta__c
						));
				}
			}
		}

		ISRUNNING = true;

		if(!lAccountLst.isEmpty()) update lAccountLst;

		ISRUNNING = false;
	}

	public static void activeMemberUser() {
		
		TriggerCheck.assert();   

		Set<Id> lIdMembersSet = new Set<Id>();
		for(FieloPLT__Member__c mb :(List<FieloPLT__Member__c>) trigger.new) {

			if(TriggerCheck.isChangedTo(mb,FieloPLT__Member__c.FieloPLT__Status__c,'Active')) {
				lIdMembersSet.add(mb.id);
			}
		}

		if(!lIdMembersSet.isEmpty()) activeUserFuture(lIdMembersSet);
	}

	public static void updateTimeZoneMemberUser() {
		
		TriggerCheck.assert();   

		Set<Id> lIdMemberSet = new Set<Id>();
		List<FieloPLT__Member__c> lMembers = new List<FieloPLT__Member__c>();
		for(FieloPLT__Member__c mb :(List<FieloPLT__Member__c>)trigger.new) {

			if(mb.FieloPLT__User__c != null && mb.FieloPLT__Program__c != null) {
				lIdMemberSet.add(mb.id);
			}				
		}

		if(lIdMemberSet.isEmpty()) return;	

		updateTimeZoneMemberUserFuture(lIdMemberSet);
	}

	@Future
	public static void updateTimeZoneMemberUserFuture(Set<Id> aIdMembersSet ) {		  

		Set<Id> lIdProgramsSet = new Set<Id>();
		List<FieloPLT__Member__c> lMembers = new List<FieloPLT__Member__c>();
		for(FieloPLT__Member__c mb :[SELECT FieloPLT__Program__c, FieloPLT__User__c 
									 FROM FieloPLT__Member__c
									 WHERE id IN :aIdMembersSet]) {

			if(mb.FieloPLT__User__c != null && mb.FieloPLT__Program__c != null) {
				lMembers.add(mb);
				lIdProgramsSet.add(mb.FieloPLT__Program__c);
			}				
		}

		if(lMembers.isEmpty()) return;

		Map<Id,Id> lUserProgramMap = new Map<Id,Id>();
		for(FieloPLT__Program__c lProgram :[SELECT OwnerId FROM FieloPLT__Program__c WHERE id IN :lIdProgramsSet]) {

			lUserProgramMap.put(lProgram.OwnerId, lProgram.id);
		}

		Map<Id,String> lTimeZoneProgramMap = new Map<Id,String>();
		for(User lUser :[SELECT id, TimeZoneSidKey FROM User WHERE id IN :lUserProgramMap.keySet()]) {

			Id lProgramId = lUserProgramMap.get(lUser.id);
			if(lProgramId != null) {

				lTimeZoneProgramMap.put(lProgramId, lUser.TimeZoneSidKey);
			}			
		}

		List<User> lUsersLst = new List<User>();
		for(FieloPLT__Member__c mb :lMembers) {

			String lTimeZone = lTimeZoneProgramMap.get(mb.FieloPLT__Program__c);
			if(lTimeZone != null) {

				lUsersLst.add(new User(id = mb.FieloPLT__User__c,TimeZoneSidKey =  lTimeZone));	
			}						
		}		

		if(!lUsersLst.isEmpty()) update lUsersLst;
	}

	@Future
	private static void activeUserFuture( Set<Id> aIdMembersSet ) {

		List<FieloPLT__Member__c> lMemberLst = [
			SELECT FieloPLT__User__c
			FROM FieloPLT__Member__c
			WHERE id IN :aIdMembersSet
			AND FieloPLT__User__c != null];

		if(lMemberLst.size() == 0) return;

		list<User> lUserLst = new list<User>();
		for(FieloPLT__Member__c mb :lMemberLst) {

			lUserLst.add( new User(
							id = mb.FieloPLT__User__c,
							IsActive = true
						)						
			);
		}	
		
		List<UserLogin> lUserLoginLst = new List<UserLogin>();
		for(userLogin ul :[SELECT IsFrozen FROM UserLogin WHERE UserId IN: lUserLst]) {

			ul.IsFrozen = false;
			lUserLoginLst.add(ul);
		}

		if(!lUserLst.isEmpty())update lUserLst;
		if(!lUserLoginLst.isEmpty())update lUserLoginLst;
	}
}