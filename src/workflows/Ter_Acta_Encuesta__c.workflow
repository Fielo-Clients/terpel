<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Ter_Alerta_Acta_Aviacion</fullName>
        <description>Esta alerta de correo electrónico se encarga de notificar al propietario sobre el acta aviación.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ter_Plantillas_Actas/Ter_Plantilla_Acta_Aviacion</template>
    </alerts>
    <alerts>
        <fullName>Ter_Alerta_Acta_EDS</fullName>
        <description>Esta alerta de correo electrónico se encarga de notificar al propietario sobre el acta EDS.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ter_Plantillas_Actas/Ter_Plantilla_Acta_EDS</template>
    </alerts>
    <alerts>
        <fullName>Ter_Alerta_Acta_GNV</fullName>
        <description>Esta alerta de correo electrónico se encarga de notificar al propietario sobre el acta GNV.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ter_Plantillas_Actas/Ter_Plantilla_Acta_GNV</template>
    </alerts>
    <alerts>
        <fullName>Ter_Alerta_Acta_Industria</fullName>
        <description>Esta alerta de correo electrónico se encarga de notificar al propietario sobre el acta industria.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ter_Plantillas_Actas/Ter_Plantilla_Acta_Industria</template>
    </alerts>
    <alerts>
        <fullName>Ter_Alerta_Acta_Rumbo</fullName>
        <description>Esta alerta de correo electrónico se encarga de notificar al propietario sobre el acta rumbo</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ter_Plantillas_Actas/Ter_Plantilla_Acta_Rumbo</template>
    </alerts>
    <alerts>
        <fullName>Ter_Alerta_Acta_comercial_GNV</fullName>
        <description>Esta alerta de correo electrónico se encarga de notificar al propietario sobre el acta comercial GNV.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ter_Plantillas_Actas/Ter_Plantilla_Acta_GNV_comercial</template>
    </alerts>
    <alerts>
        <fullName>Ter_Alerta_Acta_lubricantes</fullName>
        <description>Esta alerta de correo electrónico se encarga de notificar al propietario sobre el acta lubricantes</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ter_Plantillas_Actas/Ter_Plantilla_Acta_Lubricantes</template>
    </alerts>
    <alerts>
        <fullName>Ter_Alerta_Acta_marinos</fullName>
        <description>Esta alerta de correo electrónico se encarga de notificar al propietario sobre el acta marinos</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ter_Plantillas_Actas/Ter_Plantilla_Acta_Marinos</template>
    </alerts>
    <rules>
        <fullName>Regla envío de acta EDS</fullName>
        <actions>
            <name>Ter_Alerta_Acta_EDS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Esta regla se encarga d enviar el acta de EDS al propietario.</description>
        <formula>AND(
CreatedDate &lt;&gt; LastModifiedDate,
RecordType.Name = &quot;Acta Seguimiento Comercial EDS&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Regla envío de acta GNV</fullName>
        <actions>
            <name>Ter_Alerta_Acta_GNV</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Esta regla se encarga de enviar el acta de GNV al propietario.</description>
        <formula>AND(
CreatedDate &lt;&gt; LastModifiedDate,
RecordType.Name = &quot;Acta Seguimiento Mensual GNV&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Regla envío de acta GNV comercial</fullName>
        <actions>
            <name>Ter_Alerta_Acta_comercial_GNV</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Esta regla se encarga de enviar el acta de seguimiento comercial GNV al propietario.</description>
        <formula>AND(
CreatedDate &lt;&gt; LastModifiedDate,
RecordType.Name = &quot;Acta Seguimiento Comercial GNV&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Regla envío de acta Industria</fullName>
        <actions>
            <name>Ter_Alerta_Acta_Industria</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Esta regla se encarga d enviar el acta de industria al propietario.</description>
        <formula>AND(
CreatedDate &lt;&gt; LastModifiedDate,
RecordType.Name = &quot;Acta Seguimiento Comercial Industria&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Regla envío de acta aviación</fullName>
        <actions>
            <name>Ter_Alerta_Acta_Aviacion</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Esta regla se encarga d enviar el acta de aviación al propietario.</description>
        <formula>AND(
CreatedDate &lt;&gt; LastModifiedDate,
RecordType.Name = &quot;Acta Aviación&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Regla envío de acta lubrcantes</fullName>
        <actions>
            <name>Ter_Alerta_Acta_lubricantes</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Esta regla se encarga de enviar el acta de lubricantes al propietario.</description>
        <formula>AND(
CreatedDate &lt;&gt; LastModifiedDate,
RecordType.Name = &quot;Acta Seguimiento Comercial Lubes&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Regla envío de acta marinos</fullName>
        <actions>
            <name>Ter_Alerta_Acta_marinos</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Esta regla se encarga d enviar el acta de marinos al propietario.</description>
        <formula>AND(
CreatedDate &lt;&gt; LastModifiedDate,
RecordType.Name = &quot;Acta Marinos&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Regla envío de acta rumbo</fullName>
        <actions>
            <name>Ter_Alerta_Acta_Rumbo</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Esta regla se encarga de enviar el acta de rumbo al propietario.</description>
        <formula>AND(
CreatedDate &lt;&gt; LastModifiedDate,
RecordType.Name = &quot;Acta Seguimiento Comercial Rumbo&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
