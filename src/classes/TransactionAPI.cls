global with sharing class TransactionAPI implements FieloCMS.DataInterface{
    
    global Map<Id, Object> getBulkData(List<FieloCMS__Component__c> components){                
        Map<Id,Object> newMapData = new Map<Id,Object>();
        //Prepare all the queries
        for(FieloCMS__Component__c c : components){            
            if(c.FieloCMS__Limit__c == null)
                c.FieloCMS__Limit__c = 5;

            if(c.FieloCMS__ComponentLibrary__r.Name == 'Get Points'){
                newMapData.put(c.Id, new FieloPLT__Transaction__c());
            }else if(c.FieloCMS__ComponentLibrary__r.Name == 'Transactions'){
                Id memberId = MemberService.getCurrentMemberId();
                String approvedStatus = 'Aprobada';
                String query = 'SELECT ' + String.join(new List<String>(OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c)), ',') + ' FROM FieloPLT__Transaction__c WHERE FieloPLT__Member__c =: memberId AND FieloPLT__RevertedTransaction__c = null AND (F_Venta__r.F_Estado__c =: approvedStatus OR F_Venta__c = null)';
                query += ' LIMIT ' + String.valueOf(c.FieloCMS__Limit__c);
                newMapData.put(c.Id, Database.query(query));

                System.debug(newMapData.values());

            }                
        }
        return newMapData;
    }

    global List<sObject> getData(FieloCMS__Component__c component, Integer pageNumber, String orderBy, String filters){        
        if(component.FieloCMS__Limit__c == null)
            component.FieloCMS__Limit__c = 5;

        //Calculate the offset from the Page Number
        Integer offset = Integer.valueOf(component.FieloCMS__Limit__c * (pageNumber - 1));                
        Id memberId = MemberService.getCurrentMemberId();
        String approvedStatus = 'Aprobada';
        String query = 'SELECT ' + String.join(new List<String>(OrganizationUtil.getFieldSet(component.FieloCMS__FieldSet__c)), ',') + ' FROM FieloPLT__Transaction__c WHERE FieloPLT__Member__c =: memberId AND FieloPLT__RevertedTransaction__c = null AND (F_Venta__r.F_Estado__c =: approvedStatus OR F_Venta__c = null)';
        query += ' LIMIT ' + String.valueOf(component.FieloCMS__Limit__c);
        query += ' OFFSET ' + String.valueOf(offset);
        return Database.query(query);
    }
    
}