/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez (WRM)
Proyecto: Terpel
Descripción: Clase controladora en la que se administra la creación de pedidos por categoria de contacto. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 17-01-2017  Walter Rodríguez M (WRM)      Creación de la Clase.
***********************************************************************************/
public class Ter_CatalogoProductos_ctr
{
	private ApexPages.StandardController sController;
	public static String idContact {get;set;}
	public Product2 objProduct {get;set;}
	public Contact objContact {get;set;}
	public List<String> lstCampos {get;set;}
	public List<Product2> lstProd {get;set;}
	public List<wrpGuardarPedido> lstWrp {get;set;}
	public Boolean blnSeleccionado {get;set;}
	public Boolean blnMostrar {get;set;}
	public String strCategoria {get;set;}
	
	public Ter_CatalogoProductos_ctr(Apexpages.Standardcontroller objStandardController)
	{
		blnSeleccionado = false;
		blnMostrar = true;
		lstCampos = new list<String> { 'Id', 'Ter_Categoria__c', 'Name' };
		if(!test.isRunningTest())
			objStandardController.addFields( lstCampos );
		objContact = (Contact)objStandardController.getRecord();
		system.debug('objContact --> ' + objContact);
		system.debug('objContact Categoría --> ' + objContact.Ter_Categoria__c);
		strCategoria = objContact.Ter_Categoria__c;
		buscarProductos();
	}
	
	public void buscarProductos()
	{
		lstProd = [Select Name, Description, Id, Ter_Imagen__c, Family, ProductCode From Product2 Where Family =: objContact.Ter_Categoria__c and IsActive =: true];
		system.debug('lstProd --> ' + lstProd);
		lstWrp = new list<wrpGuardarPedido>();
		if(!lstProd.isEmpty())
		{
			for(Product2 objProd : lstProd)
			{
				wrpGuardarPedido wrpProducto = new wrpGuardarPedido();
				wrpProducto.objProducto = objProd;
				wrpProducto.blnActivo = false;
				lstWrp.add(wrpProducto);
			}
		}
	}
	
	public PageReference guardarPedido()
	{
		Boolean blnMarcado = false;
		List<Ter_Pedidos_Catalogo__c>lstPed = new List<Ter_Pedidos_Catalogo__c>();
		Ter_Pedidos_Catalogo__c objPedido;
		system.debug('lstWrp --> ' + lstWrp);
		if(!lstWrp.isEmpty())
		{
			system.debug('lstWrp.size() --> ' + lstWrp.size());
			for(wrpGuardarPedido objWrp : lstWrp)
			{
				system.debug('entro');
				if(objWrp.blnActivo)
				{
					system.debug('entro activo');
					if(objWrp.strOcasion != '')
					{
						system.debug('objWrp.objPedido.Ter_Fecha_de_entrega__c --> ' + objWrp.objPedido.Ter_Fecha_de_entrega__c);
						if(objWrp.objPedido.Ter_Fecha_de_entrega__c != null)
						{
							objPedido = new Ter_Pedidos_Catalogo__c();
							objPedido.Ter_Nombre_del_Producto__c = objWrp.objProducto.Name;
							objPedido.Ter_Fecha_de_Solicitud__c = system.today();
							objPedido.Ter_Contacto__c = objContact.Id;
							objPedido.Ter_Ejecutivo_Comercial__c = Userinfo.getUserId();
							objPedido.Ter_Ocasion__c = objWrp.strOcasion;
							objPedido.Ter_Codigo_producto__c = objWrp.objProducto.ProductCode;
							objPedido.Ter_Fecha_de_entrega__c = objWrp.objPedido.Ter_Fecha_de_entrega__c;
							lstPed.add(objPedido);
							blnMarcado = true;
						}
						else
						{
							ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'El Pedido no se puede registrar ya que se debe diligenciar la fecha de entrega.'));
							return null;
						}
					}
					else
					{
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'El Pedido no se puede registrar ya que se debe diligenciar la ocasión.'));
						return null;
					}
				}
				
			}
			try
			{
				if(blnMarcado)
				{
					insert lstPed;
					blnMostrar = false;
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'El Pedido a sido creado satisfactoriamente'));
					blnMarcado = false;
				}
				else
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Debe selecionar algún producto del catálogo para realizar el pedido.'));
			}
			catch(system.exception e)
			{
				system.debug('Error --> ' + e);
				ApexPages.addMessages(e); 
			}
		}
		return null;
	}
	
	public pagereference regresar()
	{
		Pagereference pr = new Pagereference( '/' + objContact.Id );
		pr.setRedirect(true);
		return pr; 
	}
	
	public class wrpGuardarPedido
	{
		public Product2 					objProducto						{get; set;}
		public Ter_Pedidos_Catalogo__c		objPedido						{get; set;}
		public Boolean						blnActivo						{get; set;}
		public String 						strOcasion 						{get; set;}
		public Date 						datFechaEntrega 				{get; set;}
		
		public wrpGuardarPedido()
		{
			objProducto = new Product2();
			objPedido = new Ter_Pedidos_Catalogo__c();
			blnActivo 	= false;
			strOcasion = '';
			datFechaEntrega = null;
		}
	}
}