/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez (WRM)
Proyecto: Terpel
Descripción: Clase de prueba para la clase controladora Ter_CatalogoProductos_ctr. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 14-02-2017  Walter Rodríguez M (WRM)      Creación de la Clase.
***********************************************************************************/

@isTest
private class Ter_CatalogoProductos_tst 
{
	@isTest static void test_method_save() 
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Contact objContact = Ter_DataGenerator_cls.crearContacto(true, objCuenta);
			Product2 objProducto = Ter_DataGenerator_cls.creaProducto(true);
			Ter_CatalogoProductos_ctr.wrpGuardarPedido objWrp = new Ter_CatalogoProductos_ctr.wrpGuardarPedido();
			objWrp.blnActivo = true;
			objWrp.strOcasion = 'Cumpleaños';
			objWrp.datFechaEntrega = system.today();
			Ter_Pedidos_Catalogo__c objPedido = new Ter_Pedidos_Catalogo__c();
			objWrp.objPedido = objPedido;
			objWrp.objPedido.Ter_Fecha_de_entrega__c = system.today();
			
			PageReference pageRef = Page.Ter_CatalogoProductos_pag;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController objSC = new ApexPages.StandardController( objContact );
			Ter_CatalogoProductos_ctr objCtr = new Ter_CatalogoProductos_ctr(objSC);
			objCtr.lstWrp.add(objWrp);
			objCtr.guardarPedido();
			objCtr.regresar();
		Test.stopTest();
	}
}