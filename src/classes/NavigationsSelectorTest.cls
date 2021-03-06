@isTest
private class NavigationsSelectorTest{
    @isTest
    static void itShould_1(){
        
        // Given
        FieloPLT__Program__c program1 = new FieloPLT__Program__c(Name = 'Test', SiteDomain__c = 'www.fielo.com');
        insert program1;
        
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Manual' AND SObjectType = 'FieloPLT__Segment__c'].Id;
        FieloPLT__Segment__c segment = new FieloPLT__Segment__c(
        Name = 'Test',
        RecordTypeId = rtId,
        FieloPLT__LogicalExpression__c = 'ALL'
        );
        insert segment;
        
        FieloCMS__Navigation__c navigation = new FieloCMS__Navigation__c(Name = 'Test', Segment__c = segment.Id);
        insert navigation;
        
        List<FieloCMS__Navigation__c> navigations1 = new NavigationsSelector(new Set<String>{'Name'}).selectById(new Set<Id>{navigation.Id});
        try{
            List<FieloCMS__Navigation__c> navigations2 = new NavigationsSelector(new Set<String>{'Name'}).selectByIdAndHasSegments(new Set<Id>{navigation.Id}, true);
        }catch(Exception e){
        }
    
    }
}