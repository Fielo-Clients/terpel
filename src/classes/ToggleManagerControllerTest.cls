@isTest
private class ToggleManagerControllerTest {
	
	@isTest static void test_method_one() {

		FieloPLT__Program__c lPr = SObjectForTest.getProgram('teste');
		lPr.SiteUrl__c = '';
		insert lPr;
		
		Account lAcc = SObjectForTest.getAccount();

		insert lAcc;

		List<FieloPLT__Member__c> lMemberLst = [
				SELECT id
				FROM FieloPLT__Member__c 
				WHERE FieloPLT__Account__c = :lAcc.id];

		if(lMemberLst.size() == 0) return;

		ToggleManagerController.toggleManager(lMemberLst[0].id, 'true');	
		//ToggleManagerController.toggleManager(MockUpFactory.createMember('Test', 'fielo1@fielo123.com', MockUpFactory.createProgram(), null), 'true');
		ToggleManagerController.toggleManager(null, 'true');
	}
}