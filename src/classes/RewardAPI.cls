global with sharing class RewardAPI implements FieloCMS.DataInterface,FieloCMS.ViewSubComponentInterface{

    global Map<Id, Object> getBulkData(List<FieloCMS__Component__c> components){        
        FieloPLT__Program__c program = ProgramService.getCurrentProgram();
        Map<Id,Object> newMapData = new Map<Id,Object>();
        //Prepare all the queries
        for(FieloCMS__Component__c c : components){            
            if(c.FieloCMS__Limit__c == null)
                c.FieloCMS__Limit__c = 5;

            String whereCondition = '(FieloPLT__Program__c = null OR FieloPLT__Program__c = \'' + program.Id + '\')';

            if(c.FieloCMS__Category__c != null){
                whereCondition +=  ' AND Category__c = \'' + c.FieloCMS__Category__c + '\' ';
            }
            if(c.FieloCMS__Tag__c != null){
                whereCondition +=  ' AND Id IN (  SELECT Reward__c FROM FieloCMS__TagItem__c WHERE Reward__c != NULL AND FieloCMS__Tag__c = \'' + c.FieloCMS__Tag__c + '\' )';
            }

            newMapData.put(c.Id, FieloPLT.RewardService.getRewards(OrganizationUtil.getFieldSet(c.FieloCMS__FieldSet__c), MemberService.getCurrentMemberId(), c.FieloCMS__Limit__c.intValue(), 0, c.FieloCMS__OrderBy__c, whereCondition));
        }
        return newMapData;
    }

    global List<sObject> getData(FieloCMS__Component__c component, Integer pageNumber, String orderBy, String filters){
        //Set Category or Tag from FilterBy
        String categoryId;
        String tagId;
        if(filters != null){
            Map<String,Object> filtersMap = (Map<String,Object>) JSON.deserializeUntyped(filters);
            for(String s : filtersMap.keySet()){
                if(s == 'Category__c'){
                    categoryId = (String)filtersMap.get(s);
                }else if(s == 'Tag__c'){
                    tagId = (String)filtersMap.get(s);
                }
            }
        }

        FieloPLT__Program__c program = ProgramService.getCurrentProgram();                
        if(component.FieloCMS__Limit__c == null)
            component.FieloCMS__Limit__c = 5;

        if(categoryId == null && component.FieloCMS__Category__c != null){
            categoryId = component.FieloCMS__Category__c;
        }
        if(tagId == null && component.FieloCMS__Tag__c != null){
            tagId = component.FieloCMS__Tag__c;
        }
        
        //to review performance
        Set<Id> setTaggedRewards = new Set<Id>();
        String rewardIds = null;
        if(tagId != null){
            rewardIds = '(';
            for(FieloCMS__TagItem__c tag: [SELECT Reward__c FROM FieloCMS__TagItem__c WHERE FieloCMS__Tag__c =: tagId AND Reward__c != null]){
                setTaggedRewards.add(tag.Reward__c);
                rewardIds += '\'' + tag.Reward__c + '\'' + ',';
            }
            rewardIds = rewardIds.removeEnd(',');
            rewardIds += ')';
        }    

        //Calculate the offset from the Page Number
        Integer offset = Integer.valueOf(component.FieloCMS__Limit__c * (pageNumber - 1));

        //builds the where condition
        String whereCondition = '';
        whereCondition = whereCondition + '(FieloPLT__Program__c = ' + null + ' OR FieloPLT__Program__c = \'' + program.Id + '\')';
        whereCondition += categoryId != null ? ' AND Category__c = \'' + categoryId + '\'' : '';
        whereCondition += (tagId != null && rewardIds != null) ? ' AND Id IN ' + rewardIds : '';

        return FieloPLT.RewardService.getRewards(OrganizationUtil.getFieldSet(component.FieloCMS__FieldSet__c), MemberService.getCurrentMemberId(), component.FieloCMS__Limit__c.intValue(), offset, orderBy, whereCondition);
    }

    public ApexPages.Component getSubComponent(FieloCMS.Field field, SObject record){        
        Component.AddToCart addToCart = new Component.AddToCart();
        if(record != null){
            addToCart.record = record;
        }else{
            addToCart.expressions.record = '{!record}';
        }        
        addToCart.field = field;        
        return addToCart;
    }

}