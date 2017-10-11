@isTest
private class Ter_TDC_Login_tst {
	
	@isTest static void test_method_one() {
		Test.startTest();
			Ter_TDC_Login_ctr objTerTDCLoginCtr = new Ter_TDC_Login_ctr();
			objTerTDCLoginCtr.forwardToCustomAuthPage();
			objTerTDCLoginCtr.login();
			objTerTDCLoginCtr.logout();
		Test.stopTest();
	}
}