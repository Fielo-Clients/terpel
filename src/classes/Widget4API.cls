global with sharing class Widget4API implements FieloCMS.ViewInterface{
    
    global ApexPages.Component getComponent(FieloCMS__Component__c c){                
        Component.Widget4 google = new Component.Widget4(config=c);
        return google;        
    }
    
    public Widget4API() {

    }
}