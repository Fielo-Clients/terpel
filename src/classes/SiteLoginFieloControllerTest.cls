@isTest
private class SiteLoginFieloControllerTest {

    static testMethod void checkout1(){
        FieloPLT__Program__c program = new FieloPLT__Program__c(Name = 'test');
        insert program;
        FieloPLT__Member__c member = new FieloPLT__Member__c(Name = 'test', FieloPLT__Email__c = 'test@fielo.com', FieloPLT__Program__c = program.Id, FieloPLT__User__c = UserInfo.getUserId());
        insert member;

        SiteLoginFieloController controller = new SiteLoginFieloController();

        SiteLoginFieloController.login('test@fielo.com','test');
        
        SiteLoginFieloController.forgotPassword('test@fielo.com');
        
        
    }
}