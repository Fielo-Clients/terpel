<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Fielo_ContactenosEmailNotification</fullName>
        <description>Fielo - Contactenos Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>terpel@fielo.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FieloPLT__Fielo_Templates/Fielo_Contactenos</template>
    </alerts>
    <fieldUpdates>
        <fullName>Fielo_Contactenos_MemberName</fullName>
        <field>F_Nombre__c</field>
        <formula>F_Member__r.F_NombreCompleto__c</formula>
        <name>Fielo - Contactenos - Member Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fielo_Contactenos_MemberTelefono</fullName>
        <field>F_NumeroTelefono__c</field>
        <formula>F_Member__r.F_MobilePhone__c</formula>
        <name>Fielo - Contactenos - Member Telefono</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fielo_Contactenos_Member_Email</fullName>
        <field>F_Email__c</field>
        <formula>F_Member__r.FieloPLT__Email__c</formula>
        <name>Fielo - Contactenos - Member Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Fielo - Contactenos - Con Member</fullName>
        <actions>
            <name>Fielo_Contactenos_MemberName</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Fielo_Contactenos_MemberTelefono</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Fielo_Contactenos_Member_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>!ISBLANK(F_Member__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fielo - Contactenos - Email</fullName>
        <actions>
            <name>Fielo_ContactenosEmailNotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>!ISBLANK(F_Email__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
