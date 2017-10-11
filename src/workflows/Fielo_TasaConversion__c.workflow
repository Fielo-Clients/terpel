<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Fielo_TasaDeConversion_Nombre</fullName>
        <field>Name</field>
        <formula>CASE(MONTH(F_FechaInicio__c),
1, &quot;Enero &quot;,
2, &quot;Febrero &quot;,
3, &quot;Marzo &quot;, 
4, &quot;Abril &quot;, 
5, &quot;Mayo &quot;, 
6, &quot;Junio &quot;,
7, &quot;Julio &quot;,
8, &quot;Agosto &quot;,
9, &quot;Septiembre &quot;,
10, &quot;Octubre &quot;,
11, &quot;Noviembre &quot;,
12, &quot;Diciembre &quot;,
&quot;None&quot;)
+ TEXT(YEAR(F_FechaInicio__c))</formula>
        <name>Fielo - Tasa de Conversión - Nombre</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Fielo - Tasa de Conversión - Siempre</fullName>
        <actions>
            <name>Fielo_TasaDeConversion_Nombre</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
