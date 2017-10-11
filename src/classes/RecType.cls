/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 22/05/2017
* 
* Name: RecType.cls
* 
* Class get record types
*
*******************************************************************************/
public with sharing class RecType {
  
  private static map< String, Schema.DescribeSObjectResult > fMapObjects = new map< String, Schema.DescribeSObjectResult >();
  
  public static ID getID( String aObjectName, String aRecName )
  {
    Schema.DescribeSObjectResult lObject = fMapObjects.get( aObjectName );
    if ( lObject == null )
    {
      list< Schema.DescribeSObjectResult > lListObjs = Schema.describeSObjects( new String[]{ aObjectName } );
      if ( lListObjs.size() == 0 ) return null;
      lObject = lListObjs[ 0 ];
      fMapObjects.put( aObjectName, lObject );
    }
    Schema.RecordTypeInfo lRecInfo = lObject.getRecordTypeInfosByName().get( aRecName );
    if ( lRecInfo == null ) return null;
    else return lRecInfo.getRecordTypeId();
  }

}