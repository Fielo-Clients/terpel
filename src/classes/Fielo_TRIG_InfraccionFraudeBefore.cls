/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 01/06/2017
* 
* Name: Fielo_TRIG_InfraccionFraudeBefore.cls
* 
* Class for after event of Fielo Infraccion Fraude
*
*******************************************************************************/
public with sharing class Fielo_TRIG_InfraccionFraudeBefore {

	public static boolean ISRUNNING = false;

	// Status Member	
	public final static String BLOQUEADO = 'Bloqueado';

	// Custom Settings for Variables Fraude
	private static final Fielo_VariablesFraude__c VARIABLES_FRAUDE = 
				Fielo_VariablesFraude__c.getInstance('Fielo - Club Terpel');

    private static final Integer PERIODO_INFRACCIONES = Integer.valueOf(VARIABLES_FRAUDE.F_PeriodoInfracciones__c);
    private static final Integer MAX_INFRACCIONES = Integer.valueOf(VARIABLES_FRAUDE.F_MaxInfracciones__c);

	public static void bloqueoPorReincidente() {
		
		TriggerCheck.assert();

		if ( ISRUNNING ) return;

		List<Fielo_InfraccionFraude__c> lInfraccionFraudeLst =  (List<Fielo_InfraccionFraude__c>) trigger.new;		
		
		Map<Id,Decimal> lQtdeInfraccionTriggerMap = new Map<Id,Decimal>();
		for(Fielo_InfraccionFraude__c inf :lInfraccionFraudeLst) {

			Decimal lQtdeInfraccion = lQtdeInfraccionTriggerMap.get(inf.F_Member__c);
			if(lQtdeInfraccion == null) lQtdeInfraccion = 1;
			else lQtdeInfraccion++;

			lQtdeInfraccionTriggerMap.put(inf.F_Member__c, lQtdeInfraccion);
		}
		
		List<Fielo_InfraccionFraude__c> lInfracFraudeLst = new List<Fielo_InfraccionFraude__c>();
		for(AggregateResult ar :[SELECT count(Id) qtde, F_Member__c
								FROM Fielo_InfraccionFraude__c 
								WHERE F_Member__c IN :lQtdeInfraccionTriggerMap.keySet()
								AND CreatedDate > :DateTime.Now().AddDays(-PERIODO_INFRACCIONES) 
								GROUP BY F_Member__c]) {

			Decimal lQtdeInfraccion = lQtdeInfraccionTriggerMap.get((Id)ar.get('F_Member__c'));
			if(lQtdeInfraccion == null) lQtdeInfraccion = 0;

			lQtdeInfraccion += (Decimal)ar.get('qtde');
			lQtdeInfraccionTriggerMap.put((Id)ar.get('F_Member__c'), lQtdeInfraccion);			
		}

		Map<Id,FieloPLT__Member__c> lMemberMap = new Map<Id,FieloPLT__Member__c>();
		for(Fielo_InfraccionFraude__c inf :lInfraccionFraudeLst) {

			Decimal lQtdeInfraccion = lQtdeInfraccionTriggerMap.get(inf.F_Member__c);
			if(lQtdeInfraccion == null) continue;

			if(lQtdeInfraccion > MAX_INFRACCIONES) {

				FieloPLT__Member__c lMbAux = lMemberMap.get(inf.F_Member__c);
				if(lMbAux == null) {
					lMbAux = new FieloPLT__Member__c(id = inf.F_Member__c, FieloPLT__Status__c = BLOQUEADO);
					lMemberMap.put(inf.F_Member__c, lMbAux);
				}

				lInfracFraudeLst.add( new Fielo_InfraccionFraude__c(
					F_Member__c = inf.F_Member__c,
					F_Descripcion__c = Label.Fielo_InfraccionReincidenciasFraude 
				));
			}
		}

		if(lMemberMap.values().isEmpty()) return;

		ISRUNNING = true;

		insert lInfracFraudeLst;	

		FieloPLT.SObjectService.enableAdminPermission(true);
		update lMemberMap.values();	

		ISRUNNING = false;

		// Inactive users in future method
		inactiveUserFuture(lMemberMap.keySet());
	}

	@Future
	private static void inactiveUserFuture( Set<Id> aIdMembersSet ) {

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
							IsActive = false
						)						
			);
		}	
		
		List<UserLogin> lUserLoginLst = new List<UserLogin>();
		for(userLogin ul :[SELECT IsFrozen FROM UserLogin WHERE UserId IN: lUserLst]) {

			ul.IsFrozen = true;
			lUserLoginLst.add(ul);
		}

		if(!lUserLst.isEmpty())update lUserLst;
		if(!lUserLoginLst.isEmpty())update lUserLoginLst;
	}
}