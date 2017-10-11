/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 27/06/2017
* 
* Name: Fielo_UTIL_Member.cls
* 
* Classe utilitaria
*
*******************************************************************************/
public with sharing class Fielo_UTIL_Member {
  
  public static FieloPLT__Member__c loggedMember {

    get {

      if (loggedMember == null) {

        loggedMember = getAllFieldsLoggedMember();
      }

      return loggedMember;
    }

    private set;
  }

    private static Id memId;
    public static FieloPLT__Member__c getAllFieldsLoggedMember() {

    Id lMemberId = getCurrentMemberId();
    Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get('FieloPLT__Member__c').getDescribe().fields.getMap();

        List<String> lCampos = new List<String>();//'Id';
        for (Schema.SObjectField f : fields.values()){
            Schema.DescribeFieldResult dField = f.getDescribe();
            lCampos.add(dField.getName());
            //if (dField.isCustom())
                //campos += ', ' + dField.getName();
        }
        
        List<FieloPLT__Member__c> lMembers = Database.query(
          'SELECT '+String.join(lCampos, ',')+
          ' FROM FieloPLT__Member__c'+
          ' WHERE Id =: lMemberId AND FieloPLT__Program__c = \'' + ProgramService.getProgramByDomain().Id + '\''
        );
    
    if (lMembers.size() == 1) return lMembers.get(0);
    return null;
  }

  public static Id getCurrentMemberId(){
    if(UserInfo.getUserType() == 'Guest')
        return null;

    if(memId == null){
        SessionCache__c sessionCache = SessionCache__c.getInstance(UserInfo.getUserId());
        if((sessionCache.SessionId__c == UserInfo.getSessionId() || UserInfo.getUserType() == 'Standard') && sessionCache.MemberId__c != null){
            memId = sessionCache.MemberId__c;
        }else{
            try{
                List<FieloPLT__Member__c> members = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE FieloPLT__User__c =: UserInfo.getUserId()];
                if(members.size() == 1){
                    memId = members[0].Id;
                }else{
                    Id programId = ProgramService.getProgramByDomain().Id;
                    for(FieloPLT__Member__c m : members){
                        if(m.FieloPLT__Program__c == programId){
                            memId = m.Id;
                            break;
                        }
                    }

                }
            }catch(Exception e){
                return null;
            }
        }
    }

    return memId;
  }
}