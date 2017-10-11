/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                                                    date: 22/05/2017
* 
* Name: TriggerCheck.cls
* 
* Class that context validations trigger
*
*******************************************************************************/
public with sharing class TriggerCheck { 
  
  public static void assert()
  {
    system.assert( trigger.isExecuting, 'This method must be called only in trigger context' );
  }
  
  public static boolean isChangedFrom( SObject aObj, Schema.sObjectField aField, Object aOldValue )
  {
    assert();
    if ( !trigger.isUpdate ) return false;
    Object lActualValue = aObj.get( String.valueOf(aField) );
    Object lOldValue = trigger.oldMap.get(aObj.id).get(String.valueOf(aField));
    return lActualValue != lOldValue && lOldValue == aOldValue;
  }
  
  public static boolean isChanged( SObject aObj, Schema.sObjectField aField )
  {
    assert();
    return trigger.isInsert || aObj.get( String.valueOf(aField) ) != trigger.oldMap.get( aObj.id ).get( String.valueOf(aField) );
  }
   
  public static boolean isChangedTo( SObject aObj, Schema.sObjectField aField, Object aExpectedValue )
  {
    assert();
    Object lActualValue = aObj.get( aField );
    return aExpectedValue == lActualValue 
       && ( trigger.isInsert || lActualValue != trigger.oldMap.get( aObj.id ).get( aField ) );
  }
  
  public static boolean isChangedFromTo( SObject aObj, Schema.sObjectField aField, Object aOldValue, Object aExpectedValue )
  {
    assert();
    return trigger.isUpdate 
        && aOldValue == trigger.oldMap.get( aObj.id ).get( aField )
        && aExpectedValue == aObj.get( aField );
  }
  
  public static boolean isActive( String aObjName )
  {
    TriggerConfiguration__c lConf = TriggerConfiguration__c.getValues( aObjName );
    return lConf == null || lConf.Active__c;
  }

}