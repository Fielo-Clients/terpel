/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 29/06/2017
* 
* Name: Fielo_TRIG_AccountBefore.cls
* 
* Class for before event of Account
*
*******************************************************************************/
public without sharing class Fielo_TRIG_AccountBefore {
    // Rectype of Account
    public final static String TARJETA_PREINSCRITA_ID = RecType.getID('Account', 'Tarjeta Preinscrita');

    public final static String TIPO_FISICA = 'Física';
    public final static String TIPO_VIRTUAL = 'Virtual';
    public final static String TIPO_MEMBER_TARJETA = 'Fielo_TarjetaPreinscrita';    

    public static void nuevaTarjeta() {

        TriggerCheck.assert();  

        for(Account acc :(List<Account>) trigger.new) {

            if(acc.F_CodigoTarjetaPreinscrita__c != null && 
                (acc.F_TipoTarjetaPreinscrita__c == TIPO_FISICA || 
                acc.F_TipoTarjetaPreinscrita__c == TIPO_VIRTUAL)) {

                acc.RecordTypeId = TARJETA_PREINSCRITA_ID;
                acc.F_TipoMember__c = TIPO_MEMBER_TARJETA;
                acc.F_CreateMember__c = true;
                if(acc.LastName == null){
                    acc.LastName = acc.F_CodigoTarjetaPreinscrita__c;
                }
                if(acc.PersonEmail == null){
                    acc.PersonEmail = acc.F_CodigoTarjetaPreinscrita__c + '@clubterpel.com';
                }
            }
        }
    }
}