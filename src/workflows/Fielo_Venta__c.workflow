<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Fielo_Venta_RuleTrigger</fullName>
        <field>F_RuleTrigger__c</field>
        <formula>TEXT(F_TipoTransaccion__c) + TEXT(F_Estado__c )</formula>
        <name>Fielo - Venta  - Rule Trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Fielo - Venta - Rule Trigger</fullName>
        <actions>
            <name>Fielo_Venta_RuleTrigger</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() ||
ISCHANGED(F_TipoTransaccion__c ) ||
ISCHANGED(F_Estado__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
