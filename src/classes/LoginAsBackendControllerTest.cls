@isTest
private class LoginAsBackendControllerTest {

	@isTest(seeAllData=false) static void redirectSuccessful() {
		//crate new member with user
		/*MockUpFactory.setCustomProperties(false);
		Member__c member = new Member__c(LastName__c = 'test member');
		insert member;
				
		LoginAsBackendController controller = new LoginAsBackendController();
		system.currentPageReference().getParameters().put('memberId',member.Id);		
		controller.redirect();*/
	}
	
}