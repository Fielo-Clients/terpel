global without sharing class RegisterStep2Controller {
        
    public FieloPLT__Member__c member {get{
        if(member == null){     
            Id memberId = ApexPages.currentPage().getParameters().get('memberId');
            try{
                member = Database.query('SELECT ' + getFieldSet() + ' FROM FieloPLT__Member__c WHERE Id =: memberId LIMIT 1');
            }catch(Exception e){}
        }
        return member;
    } set;}

    private String getFieldset(){
        List<String> fields = new List<String>{'Id'};
        for(Schema.FieldSetMember fsm : Schema.SObjectType.FieloPLT__Member__c.fieldSets.RegistrationStep2.getFields()){
            fields.add(fsm.getFieldPath());
        }    
        return String.join(fields,',');
    }

    public Boolean showForm {get{if(!initLoaded) init(); return showForm;} private set;}
    public Boolean memberAlreadyRegistered {get{if(!initLoaded) init(); return memberAlreadyRegistered;} private set;}
    public Boolean memberInApproval {get{if(!initLoaded) init(); return memberInApproval;} private set;}
    public Boolean showContinue {get{if(!initLoaded) init(); return showContinue;} private set;}

    public String status {get{if(!initLoaded) init(); return status;} private set;}

    private Boolean initLoaded;
    public RegisterStep2Controller(){
        initLoaded = false;
    }

    private void init(){
        initLoaded = true;        
        Id memberId = member != null ? member.Id : null;        
        status = FieloPLT.MemberService.validateStatus(memberId);
    }
    
    @RemoteAction
    global static FieloCMS.RemoteActionResult continueRegistration(Id memberId){
        SavePoint sp = Database.setSavepoint();
        FieloCMS.RemoteActionResult result = new FieloCMS.RemoteActionResult();
        try{
            FieloPLT__Member__c member = new MembersSelector().selectById(new Set<Id>{memberId})[0];
            FieloPLT.MemberService.finishRegistration(member);
            //MemberUtil.sendToApprove(new List<Member__c>{member});
            result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, Label.SucessAwardingApprovalRegistration)));
        }catch(FieloException e){
            Database.rollback(sp);
            result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(e));
        }catch(FieloPLT.FieloException e){
            result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(e));
        }

        if(ApexPages.hasMessages()){
            result.redirectURL = '';
            for(ApexPages.Message m : ApexPages.getMessages()){
                result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(m));
            }
        }

        return result;
    }

    @RemoteAction
    global static FieloCMS.RemoteActionResult finishRegistration(SObject record, String password){    
        SavePoint sp = Database.setSavepoint();
        FieloCMS.RemoteActionResult result = new FieloCMS.RemoteActionResult();
        try{
            FieloPLT__Member__c member = (FieloPLT__Member__c)record;                
            FieloPLT.MemberService.finishRegistration(member);
            if(!String.isBlank(password)){
                PageReference passResult = MemberService.setPasswordAndLogin(record.Id, password);
                result.redirectURL = passResult.getUrl();
            }else{
                result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, Label.RegistrationSuccessExistingUser)));
            }
        }catch(DmlException e){            
            Database.rollback(sp);
            if(ApexPages.hasMessages()){
                result.redirectURL = '';
                for(ApexPages.Message m : ApexPages.getMessages()){
                    result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(m));
                }
            }else{
                result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(e));
            }
        }catch(Exception e){            
            Database.rollback(sp);            
            result.addMessage(new FieloCMS.RemoteActionResult.RemoteActionMessage(e));
        }
        return result;                
    }  
}