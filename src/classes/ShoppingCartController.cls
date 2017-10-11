global with sharing class ShoppingCartController {
    //  Estado Autorizacion LifeMiles
    public final static String PENDIENTE = 'Pendiente';

    //  Tipo Transaccion Autorizacion LifeMiles
    public final static String DEBITO = 'Débito (D)';

    //  Status Redemption
    public final static String CLOSED = 'Closed';
    public final static String REJECTED = 'Rejected';

    //  Reward Stock Management type
    public final static String UNLIMITED = 'Unlimited';
    
    public static FieloPLT__Member__c fMember {
        get{
            if(fMember == null) {
                fMember = Fielo_UTIL_Member.loggedMember;
            }
            return fMember;
        }
        set;
    }

    public List<FieloPLT__Reward__c> rewards {get{
        if(rewards == null){
            Set<Id> rewardIds = quantitiesMap.keySet();
            rewards = Database.query('SELECT ' + getFieldSet() + ' FROM FieloPLT__Reward__c WHERE Id in : rewardIds');
        }
        return rewards;
    } set;}

    public Map<Id,Integer> quantitiesMap {get{
        if(quantitiesMap == null){
            Cookie shopCartCookie = ApexPages.currentPage().getCookies().get('shoppingCart');
            if(shopCartCookie != null && !String.isBlank(shopCartCookie.getValue())){
                quantitiesMap = (Map<Id,Integer>)JSON.deserialize(shopCartCookie.getValue().replace('\'','"'),Map<Id,Integer>.class);
            }else{
                quantitiesMap = new Map<Id,Integer>();
            }
        }
        return quantitiesMap;
    } set;}

    public Integer totalItems {get{
            if(totalItems == null){
                totalItems = 0;
                for(Integer quant : quantitiesMap.values()){
                    totalItems += quant;
                }
            }
            return totalItems;
        } set;}

    public Map<Id,Integer> totalPointsMap {get{
        if(totalPointsMap == null){
            totalPointsMap = new Map<Id,Integer>();
            for(FieloPLT__Reward__c reward : rewards){
                totalPointsMap.put(reward.Id, (quantitiesMap.get(reward.Id) * reward.FieloPLT__Points__c).intValue());
            }
        }
        return totalPointsMap;
    } set;}

    public Integer totalPointsItems {get{
        if(totalPointsItems == null){
            totalPointsItems = 0;
            for(Integer quant : totalPointsMap.values()){
                totalPointsItems += quant;
            }
        }
        return totalPointsItems;
    } set;}

    private String getFieldset(){
        Set<String> fields = new Set<String>{'Id','FieloPLT__Points__c','FieloPLT__StockManagement__c,FieloPLT__Stock__c'};
        for(Schema.FieldSetMember fsm : Schema.SObjectType.FieloPLT__Reward__c.fieldSets.ShoppingCart.getFields()){
            fields.add(fsm.getFieldPath());
        }
        return String.join(new List<String>(fields),',');
    }

    @RemoteAction
    global static FieloCMS.RemoteActionResult checkout(Id componentId, String newQuantJSON){
        FieloCMS__Component__c component = [SELECT FieloCMS__DetailParameter__c, RedirectPage__c, F_RedirectErrorPage__c FROM FieloCMS__Component__c WHERE Id =: componentId];
        FieloCMS.RemoteActionResult result = new FieloCMS.RemoteActionResult();
        if(fMember != null) {             
             
            if(String.isNotBlank(newQuantJSON)){
                Map<Id,Integer> quantitiesMap = (Map<Id,Integer>)JSON.deserialize(newQuantJSON, Map<Id,Integer>.class);
                Decimal lTotalPoints = 0;
                Decimal lTotalMonto = 0;
                Boolean lErrorQtdItens = false;
                for(FieloPLT__Reward__c lReward :[SELECT FieloPLT__Points__c, FieloPLT__StockManagement__c, FieloPLT__Stock__c, 
                                                    F_Monto__c, Name 
                                                    FROM FieloPLT__Reward__c
                                                    WHERE id IN :quantitiesMap.keySet()]) {
                    Decimal lRewardQtd = quantitiesMap.get(lReward.id);
                    if(lRewardQtd != null && lRewardQtd > 0) {
                        if(lReward.FieloPLT__Points__c != null) {
                            lTotalPoints += lReward.FieloPLT__Points__c * lRewardQtd;
                        }
                        if(lReward.F_Monto__c != null) {
                            lTotalMonto += lReward.F_Monto__c * lRewardQtd;
                        }
                        if(lReward.FieloPLT__StockManagement__c != UNLIMITED && lRewardQtd > lReward.FieloPLT__Stock__c) {
                            result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Fielo_RedencionItemsInsuficientes + (': ' + lReward.Name + ' - Disponible: ' + lReward.FieloPLT__Stock__c))));
                            lErrorQtdItens = true;
                        }  
                    } 
                    else {
                        result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Fielo_RedencionItemNulo + (': ' + lReward.Name))));
                        lErrorQtdItens = true;
                    }         
                }
                if(!lErrorQtdItens) {
                    if(lTotalPoints <= fMember.F_BalanceLifeMiles__c) {  
                        // Se ejecuta el callout antes del método "createRedemptions" 
                        // porque este método efectúa un DML y no se permite DML antes de un callout
                        Fielo_Autorizacion_LifeMiles__c lAutorizacionLM;
                        lAutorizacionLM = redencionVirtual(lTotalPoints, lTotalMonto);                          

                        Savepoint sp = Database.setSavepoint();
                        try{
                            insert lAutorizacionLM;

                            PageReference retPage = Page.FieloCMS__Page;
                            if(lAutorizacionLM.F_CodigoRespuestaLM__c == '000') {

                                FieloPLT__Redemption__c redemption;
                                redemption = FieloPLT.RedemptionService.createRedemptions(quantitiesMap, fMember.id)[0];
                                redemption.F_AutorizacionLifeMiles__c = lAutorizacionLM.id;
                                redemption.F_Tipo__c = 'Virtual';                            
                                redemption.FieloPLT__Status__c = CLOSED;

                                update redemption;

                                if(redemption.FieloPLT__Status__c == CLOSED){
                                    
                                    retPage.getParameters().put('pageId',component.RedirectPage__c);
                                    retPage.getParameters().put(component.FieloCMS__DetailParameter__c,redemption.Id);
                                }else{
                                    result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, Label.InfoRedemptionApproval)));
                                }
                            }
                            else {
                                retPage.getParameters().put('pageId',component.F_RedirectErrorPage__c);                               
                            }   
                            result.redirectURL = retPage.getUrl().replace('/apex','');                           
                        }catch(DMLException e){
                            Database.rollBack(sp);
                            result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(ApexPages.Severity.ERROR, e.getDmlMessage(0)));
                        }catch (Ter_AcumulacionException e) {
                            result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage() ));
                        } 
                        catch(FieloPLT.FieloException e) {
                            result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(ApexPages.Severity.ERROR, e.getMessage() ));
                        }                         
                    }else{
                        result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Fielo_RedencionMillasInsuficientes)));
                    } 
                }                                
            }               
        }else{
            result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Participante no localizado.')));
        }

        if(ApexPages.hasMessages()){
            result.redirectURL = '';
            for(ApexPages.Message m : ApexPages.getMessages()){
                result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(m));
            }
        }

        return result;
    }

    private static Fielo_Autorizacion_LifeMiles__c redencionVirtual(Decimal aTotalPoints, Decimal aTotalMonto) {

        Ter_LifeMilesConversionWsConsumer_cls objLifeMilesConversionWsConsumer = new Ter_LifeMilesConversionWsConsumer_cls();
        Ter_ResponseRedentionDTO_cls objResponse;

        Fielo_Autorizacion_LifeMiles__c lAutorizacionLM =  new Fielo_Autorizacion_LifeMiles__c();
        lAutorizacionLM.F_MillasBase__c = aTotalPoints;
        lAutorizacionLM.F_MontoTransaccion__c = aTotalMonto;        
        lAutorizacionLM.F_TipoTransaccion__c = DEBITO;
        lAutorizacionLM.F_IdTransaccion__c = Ter_Utilidades_cls.obtenerTransaccionIdLifeMiles();
        lAutorizacionLM.F_Estado__c = PENDIENTE;
        lAutorizacionLM.F_NumeroLifeMiles__c = fMember.F_NumeroLifeMiles__c;
        lAutorizacionLM.F_Member__c = fMember.id;

        objResponse = objLifeMilesConversionWsConsumer.invokePostMilesStr(lAutorizacionLM, null, fMember.F_SessionId__c);

        //La respuesta se puede procesar asi:
        map<String, String> mapCodigosError;
        mapCodigosError = Ter_Utilidades_cls.obtenerCodigosError(label.Ter_lbl_TipoTransaccion_Redencion);
                
        lAutorizacionLM.F_CodigoRespuestaLM__c = objResponse.getBody().getPostingResponse().getResponse_code();

        if(!label.Ter_lbl_Codigo_Exito_Redencion_LM.equals(objResponse.getBody().getPostingResponse().getResponse_code())){
            lAutorizacionLM.F_Estado__c = 'Rechazado';
            if(mapCodigosError.containsKey(objResponse.getBody().getPostingResponse().getResponse_code())){
                lAutorizacionLM.F_MotivoRechazo__c = mapCodigosError.get(objResponse.getBody().getPostingResponse().getResponse_code());
            } else{
                lAutorizacionLM.F_MotivoRechazo__c = label.Ter_lbl_Error_General_Redencion;
            }
        } else{
            lAutorizacionLM.F_NumeroAutorizacionLM__c = objResponse.getBody().getPostingResponse().getAutho_num();
            lAutorizacionLM.F_Estado__c = 'Aprobado';
        }
        return lAutorizacionLM;
    }

    public void dummy() {

    }

    public PageReference returnCatalog() {
        List<FieloCMS__Navigation__c> lNavigationLst = [SELECT FieloCMS__Url__c FROM FieloCMS__Navigation__c where Name = 'Redime tus millas'];
        if(lNavigationLst.size() == 0) return null;
        return new PageReference(lNavigationLst[0].FieloCMS__Url__c);
    }
}