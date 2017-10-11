@isTest
private class Widget3APITest
{
	@isTest
	static void testeSemCampos()
	{
		FieloPLT__Member__c LMemberCliente =  createMemberByAccount();

		Test.startTest();	

		system.runAs(LMemberCliente.FieloPLT__User__r) {

			Widget3API lTela = new Widget3API();
			lTela.enviar();

		}
		Test.stopTest();

	}

	@isTest
	static void testeComCampos()
	{
		FieloPLT__Member__c LMemberCliente =  createMemberByAccount();

		Test.startTest();


		system.runAs(LMemberCliente.FieloPLT__User__r) {

			Widget3API lTela = new Widget3API();
			Widget3API.fNombre = 'teste';
		    Widget3API.fEmail = 'teste';
		    Widget3API.fTelefono = 'teste';
		    Widget3API.fAsunto = 'teste';
		    Widget3API.fDescripcion = 'teste';	
			lTela.enviar();

		}
		Test.stopTest();

	}

	private static FieloPLT__Member__c createMemberByAccount() {

		FieloPLT__Program__c lPr = SObjectForTest.getProgram('teste');
		lPr.SiteUrl__c = '';
		insert lPr;

		Account lAcc = SObjectForTest.getAccount();

		insert lAcc;

		return [SELECT FieloPLT__Email__c, FieloPLT__User__c, FieloPLT__User__r.userName
				FROM FieloPLT__Member__c 
				WHERE FieloPLT__Account__c = :lAcc.id];
	}
}