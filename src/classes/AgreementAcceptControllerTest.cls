@isTest
private class AgreementAcceptControllerTest{
    @isTest
    static void itShould_1(){
        // Given
        FieloPLT__Program__c program = new FieloPLT__Program__c(Name = 'Test', SiteDomain__c = 'www.fielo.com');
        insert program;
        
        FieloPLT__Agreement__c agreement = new FieloPLT__Agreement__c(
            FieloPLT__Agreement__c = 'test',
            FieloPLT__Program__c = program.Id
        );
        insert agreement;
        
        agreement.FieloPLT__Status__c = 'Current';
        update agreement;

        FieloPLT__Member__c member = new FieloPLT__Member__c(
            Name = 'test', 
            FieloPLT__Email__c = 'test@fielo.com', 
            FieloPLT__Program__c = program.Id, 
            FieloPLT__User__c = UserInfo.getUserId()
        );
        insert member;
        
        MemberService.setCurrentMemberId(member.Id);
        
        AgreementAcceptController controller = new AgreementAcceptController();
        controller.agreement = agreement;
        AgreementAcceptController.doSave();
    
    }
}