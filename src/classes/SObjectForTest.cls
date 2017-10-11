/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 29/05/2017
* 
* Name: SObjectForTest.cls
* 
* Classe que possui os objetos que auxiliam na criação de classes de teste
*
*******************************************************************************/

@isTest
public class SObjectForTest {    
    // Rectype of Account
    public final static String PERSON_TERPEL_ID = RecType.getID('Account', 'Cliente Terpel');

    public static FieloPLT__Member__c getMember(String aName, Id aPrg){

        return new FieloPLT__Member__c(
             Name = aName,
             FieloPLT__Email__c = aName.deleteWhitespace() + Datetime.now().getTime() + '@fielo.com',
             FieloPLT__Program__c = aPrg,
             FieloPLT__Type__c = 'Individual Account'
        );
    }


    public static FieloPLT__Program__c getProgram(String aName) {

        return new FieloPLT__Program__c(
             Name = aName,
             FieloPLT__OnlineTransactionProcessing__c = true
         );
     }

    public static User loadUserLoggedMember (){    
                             
        FieloPLT__Program__c lPrg = getProgram('Teste'); 
        insert lPrg;  
                                
        Account lAcc = getAccount();
        insert lAcc;

        return [SELECT FieloPLT__User__r.UserName
                FROM FieloPLT__Member__c 
                WHERE FieloPLT__Account__c = :lAcc.id].FieloPLT__User__r;                                                                           
    }

    public static FieloPLT__Library__c getLibrary() {

        return new FieloPLT__Library__c(

                FieloPLT__ResourceId__c = '0810v0000004CrjAAE',
                FieloPLT__Version__c = 2.001
            );
    }

    public static FieloPLT__Member__c loadMember(){    
                                
        Account lAcc = getAccount();
        insert lAcc;

        return [SELECT id, FieloPLT__Email__c, FieloPLT__Account__c 
                FROM FieloPLT__Member__c 
                WHERE FieloPLT__Account__c = :lAcc.id Limit 1];                                                                             
    }
    
    public static User getUser( ID aProfileId )
    {
        return getUser( aProfileId, null );
    }
    
    public static User getUser( ID aProfileId, String aSuffix )
    {
        boolean lHasSuffix = String.isBlank( aSuffix );
        return new User(
            Username = 'usuarioteste@valuenet.com.br' + ( lHasSuffix ? '':aSuffix ),
            Email = 'nome@empresa.com',
            LastName = 'Sobrenome',
            Alias = 'VN' + ( lHasSuffix ? '':aSuffix.left( 2 ) ),
            CommunityNickname = 'vnscteste' + ( lHasSuffix ? '':aSuffix ),
            EmailEncodingKey = 'ISO-8859-1',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'pt_BR',
            LanguageLocaleKey = 'pt_BR',
            ProfileId = aProfileId
        );
    }
    
    public static Profile getProfile( String aProfileName )
    {
        return [ Select Id From Profile Where Name=:aProfileName Limit 1 ];
    }
    
    public static FieloPLT__Redemption__c getRedemption( Id aMemberId )
    {
        return new FieloPLT__Redemption__c(
            FieloPLT__Member__c = aMemberId        
        );
    }

    public static FieloPLT__RuleTrigger__c getRuleTrigger(){

        return new FieloPLT__RuleTrigger__c(
            Name = 'Event',     
            FieloPLT__Date__c = 'CreatedDate',
            FieloPLT__LookupFromTransaction__c = 'FieloPLT__Event__c', 
            FieloPLT__LookupfromTracker__c = 'FieloPLT__Event__c', 
            FieloPLT__Object__c = 'FieloPLT__Event__c', 
            FieloPLT__Prefix__c = 'a0L', 
            FieloPLT__ConditionValue__c = 'Registration'
        );

    }   

    public static FieloPLT__Action__c getAction(String aRuleTrigger){

        return new FieloPLT__Action__c(
            name = 'Event > FieloPLT__Member__c',
            FieloPLT__RulesQuantity__c = 1,
            FieloPLT__DeveloperName__c = 'FieloPLT__Event__c>FieloPLT__Member__c',
            FieloPLT__RuleTrigger__c = aRuleTrigger,
            FieloPLT__TargetMember__c = 'FieloPLT__Member__c' 
        );

    }

    public static FieloPLT__Reward__c getReward(Id aProgramId)
    {
        return new FieloPLT__Reward__c(
            FieloPLT__Program__c = aProgramId,
            FieloPLT__Points__c = 200,
            Name = 'Serviço teste ' + Datetime.now().getTime(),
            FieloPLT__Stock__c = 10000,
            FieloPLT__UniqueVoucher__c = true,
            FieloPLT__ExpirationDate__c = system.today().addDays(100)

        );
    }
    
    public static FieloPLT__RewardItem__c getRewardItem( id arewardId )
    {
        return new FieloPLT__RewardItem__c(
            FieloPLT__Reward__c = arewardId,
            FieloPLT__Quantity__c = 1
        );
    }
    
    public static FieloPLT__RedemptionItem__c getRedemptionItem( Id aredemptionId, 
        Id arewardId, Id arewardItemId )
    {
        return new FieloPLT__RedemptionItem__c(
            FieloPLT__Redemption__c = aredemptionId,
            FieloPLT__RewardItem__c = arewardItemId,
            FieloPLT__Reward__c = arewardId,
            FieloPLT__Quantity__c = 1
        );
    }

    public static FieloPLT__Rule__c getRule(String aName){

        return new FieloPLT__Rule__c(
            Name = aName,
            FieloPLT__PointConversionMode__c = 'Fixed Value',
            FieloPLT__ConversionValue__c = 1
        );
    }

    public static FieloPLT__ProgramPointType__c getProgramPointType(){

        return new FieloPLT__ProgramPointType__c(
            FieloPLT__AuditPoints__c = true,
            FieloPLT__RequestPointApproval__c = false
        );
    
    }
    public static FieloPLT__Promotion__c getPromotion(){

        return new FieloPLT__Promotion__c(
            Name = 'Promotion Teste',
            FieloPLT__StartDate__c = system.today() - 1,
            FieloPLT__EndDate__c = system.today() + 1,
            FieloPLT__Status__c = 'Draft',
            F_Default__c = false,
            F_MontoConsumido__c = 0,
            F_Presupuesto__c = 100
        );
    
    }

    public static FieloPLT__PointType__c getPointType(){

        return new FieloPLT__PointType__c(
            Name = 'Millas LifeMiles', 
            FieloPLT__MemberBalanceField__c = 'FieloPLT__Points__c',
            FieloPLT__RedemptionBalanceField__c = 'FieloPLT__Points__c',
            FieloPLT__RedemptionItemBalanceField__c = 'FieloPLT__Points__c',
            FieloPLT__RewardBalanceField__c = 'FieloPLT__Points__c',
            FieloPLT__TransactionBalanceField__c = 'FieloPLT__Points__c',
            F_TarifaMillaUSD__c = 0.0095
        );
    
    }

    public static FieloPLT__Point__c getPoint(Id aMemberId, Id aRuleId){

      return new FieloPLT__Point__c(
       FieloPLT__Member__c = aMemberId,
       FieloPLT__TotalPoints__c = 10,
       FieloPLT__Rule__c = aRuleId
      );
    
    }

    public static FieloPLT__Point__c getPoint(Id aMemberId){
      return new FieloPLT__Point__c(
       FieloPLT__Member__c = aMemberId,
       FieloPLT__TotalPoints__c = 10
      );
    
    }

    public static FieloPLT__Transaction__c getTransaction(Id aMemberId){
      return new FieloPLT__Transaction__c(        
       FieloPLT__Member__c = aMemberId,
       FieloPLT__Points__c = 10,
       FieloPLT__Value__c = 500
      );
    }

    public static Attachment getAttachment( String aParentId) {

        Blob b = Blob.valueOf('Test Data');

        return new Attachment(
            ParentId = aParentId,
            Name = 'Test Attachment for Parent', 
            Body = b
        );
    } 

    public static Document getDocument(String aName)
    {
        return new Document(
            Name = aName,
            FolderId = UserInfo.getUserId(),
            AuthorId = UserInfo.getUserId()
        );
    }

    public static EmailTemplate getEmailTemplate ()
    {
        return new EmailTemplate(
            Subject = 'Teste@email.com',
            HtmlValue = '<html></html>',
            Body = 'Conteudo',
            Name = 'Meus colaboradores - Novo colaborador'
            );
    }


    public static Lead getLead(){
        return new Lead(
            FirstName='testNome',
            LastName='rd',
            Email='testEmail@test.com',
            Company='testEmpresa',
            Phone='12345678'
        );  
    }
    
    public static Account getAccount() 
    {
        return new Account(
            F_CreateMember__c = true,
            F_TipoMember__c = 'Fielo_ClienteTerpel',
            RecordTypeId = PERSON_TERPEL_ID,
            F_NumeroLifeMiles__c = '123456789ASD',
            FirstName = 'Moura',
                MiddleName = 'Teles',
            LastName = 'Teles', Suffix = 'tele',
            PersonBirthdate = Date.newInstance(1981,5,11),
            PersonEmail = 'moura@eu.com',
            PersonHomePhone = '18998877233',
            PersonMobilePhone = '18998877233',
            Ter_Genero__pc = 'F',
            Ter_Tipo_documento__pc = 'Cédula de ciudadanía',
            Ter_Pais_documento__pc = 'Brasil',
            Ter_Numero_de_identificacion__c = '98989898',
            PersonMailingStreet = 'Rua São João',
            BillingStreet = 'Rua São João',
            PersonMailingCity = 'Paraguaçu Paulista',
            BillingCity = 'Paraguaçu Paulista',
            PersonMailingState = 'SP',
            BillingState = 'SP',
            PersonMailingPostalCode = '19700550',
            PersonMailingCountry = 'BR',
            BillingCountry = 'BR',
            Ter_Tipo_de_vehiculo__c = 'Camión',
            Ter_OperadorCelular__c = 'Movistar',
            F_TipoTarjetaPreinscrita__c = null,
            F_CodigoTarjetaPreinscrita__c = null,
            F_ClubTerpelAgreementAccepted__c = true,
            F_ClubTerpelAgreementDate__c = Date.newInstance(2017,6,11),
            F_SessionId__c = '123456789ja',
            F_BalanceLifeMiles__c = 112233
        );
    }
    
    public static Contact getContact()
    {
        return new Contact(
            FirstName = 'Name',
            LastName = 'Contact'
        );
    }
    
    public static Opportunity getOpportunity()
    {
        return new Opportunity(
            Name = 'Opportunity for Test',
            StageName = 'Closed Won',
            CloseDate = system.today()
        );
    }
    
    public static OpportunityLineItem getOpportunityLineItem( id aOppId, id aPBEId )
    {
            return new OpportunityLineItem( 
                        OpportunityId = aOppId,
                        Quantity = 1,
                        PricebookEntryId = aPBEId,
                        TotalPrice = 1
            );
    }
     
    public static id getStandartPricebookId()
    {
        return system.Test.getStandardPricebookId();
    }
    
    public static product2 getProduct2()
    {
            return new Product2(
                Name = 'Teste'
            );
    }
    
    public static PricebookEntry getPricebookEntry( ID aPriceBookId, ID aProductId )
    {
        return new PricebookEntry(
            Pricebook2Id = aPriceBookId,
            Product2Id = aProductId,
            IsActive = true,
            UnitPrice = 1.00
        );
    }
    
    public static Fielo_TasaConversion__c getTasaConversion()
    {
        return new Fielo_TasaConversion__c(
            F_FactorConversion__c = 1,
            F_FechaInicio__c = system.today().addDays(-1),
            F_FechaFin__c = system.today().addDays(+1),
            F_ConversionMonedas__c = 'COP -> USD'
        );
    }
    
    public static Fielo_Venta__c getVenta()
    {
        return new Fielo_Venta__c(
            F_Estado__c  = 'Procesar',
            F_OrigenVenta__c = 'Estación de Servicio',
            F_MontoTotal__c = 100,
            F_IdPromotorCajero__c = '01234'
        );
    }   
    
    public static Fielo_MedioDePago__c getMedioDePago()
    {
        return new Fielo_MedioDePago__c(            
            F_Estado__c = 'Activo',
            F_IdMedioDePagoEDS__c = '999',
            F_IdMedioDePagoTTCC__c = '999'
        );
    }
    
    public static Fielo_MedioDePagoVenta__c getMedioDePagoVenta()
    {
        return new Fielo_MedioDePagoVenta__c(
            F_Monto__c = 100
        );
    }   
    
    public static Fielo_ItemVenta__c getItemVenta()
    {
        return new Fielo_ItemVenta__c(
            F_Cantidad__c = 2,
            F_IdProducto__c = '09876',
            F_ValorUnitario__c = 5.0
        );
    }
    
    public static Ter_Estacion_de_Servicio__c getEstacionDeServicio()
    {
        return new Ter_Estacion_de_Servicio__c(
            Name = 'Estacion Serviço teste',
            Ter_Direccion__c = '25 de Mayo 424',
            Ter_Ciudad__c = 'Buenos Aires',
            Ter_Departamento__c = 'San Isidro',
            Ter_Estatus__c = 'Activa',
            Ter_Marca__c = 'Terpel',
            Ter_Segmento__c = 'EDS PROPIAS (POD)',
            Ter_Codigo_unico__c = '123456'
        );
    }
    
    public static Fielo_VariablesFraude__c getVariablesFraude()
    {
        return new Fielo_VariablesFraude__c(
            Name = 'Fielo - Club Terpel',
            F_MaxInfracciones__c = 2,
            F_MaxCantidadVentasLiquido__c = 2,
            F_MaxCantidadVentasTienda__c = 2,
            F_CodigosCombustibleCorriente__c = '1,2,3',
            F_CodigosCombustibleDiesel__c = '7,8,9',
            F_CodigosCombustibleExtra__c = '4,5,6',
            F_MaxGalonesCorriente__c = 50,
            F_MaxGalonesDiesel__c = 60,
            F_MaxGalonesExtra__c = 55,
            F_MaxMontoVentaTienda__c = 1000,
            F_PeriodoInfracciones__c = 1,
            F_MinTiempoEntreVentas__c = 120
        );
    }   
}