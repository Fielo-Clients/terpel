/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez (WRM)
Proyecto: Terpel
Descripción: Clase controladora en la que se administra la generación del PDF por EDS. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 23-01-2017  Walter Rodríguez M (WRM)      Creación de la Clase.
***********************************************************************************/
public class Ter_GenerarPDF_ctr 
{
    public List<String> lstCampos {get;set;}
    public List<Ter_Estacion_de_Servicio__c > lstEDS {get;set;}
    public list<EventWhoRelation> lstEvenWho {get;set;}
    public list<Contact> lstContact {get;set;}
    public Ter_Acta_Encuesta__c objActa {get;set;}
    public String strFechaVisita {get;set;}
    public Boolean blnMostrar {get;set;}
    
    public Ter_GenerarPDF_ctr(ApexPages.StandardController objStandardController)
    {
        blnMostrar = true;
        lstCampos = new list<String> { 'Id', 'Name', 'Ter_Nombre_EDS__c', 'Bit_cora_ambiental__c', 'Canal_perimetral_zona_islas__c', 'Ter_Canal_perimetral_zona_islas_segu_inf__c',
                                        'Caja_de_contenci_n_de_equipos__c', 'Caja_de_conteci_n_de_equipos__c', 'Valvula_de_impacto__c', 'Fugas_en_v_lvula_de_impacto__c', 'Break_away__c', 
                                        'Pistolas__c', 'Ter_Locativos_zona_de_islas_Decreto_1521__c', 'Ter_Trampa_de_grasas_zona_combustibles__c', 'Ter_Existencias_en_trampa_de_grasas__c', 
                                        'Fugas_en_codo_giratorio__c', 'Equipo_de_repuesta_a_derrames__c', 'Ter_Solidos_en_trampa_de_grasas__c', 'Forro_pistolas__c', 'Ter_Extintores_pil_segridad_ope__c',
                                        'Instalaciones_el_ctricas__c', 'Parada_de_emergencia__c', 'Elementos_puedan_caer_del_canopy__c', 'Extintores__c', 'Se_alizaci_n_islas__c', 'Caja_contenedora_de_bombas__c',
                                        'Spill_Container__c', 'Pozo_de_monitoreo__c', 'Manejo_de_residuos__c', 'Ter_Caja_contenedora_de_bombas_amb_ope__c', 'Salmuera_en_tanque_de_almacenamiento__c',
                                        'Bocas_tanques_de_almacenamiento_cerradas__c', 'Ausencia_de_s_lidos_en_spill_container__c', 'Ter_Ausencia_combustible_pozo_de_monit__c', 'Manejo_de_residuos__c',
                                        'Tanques_de_almacenamiento__c', 'Puesta_a_tierra__c', 'Se_alizaci_n_descargue_de_combustible__c', 'Prueba_de_tanques__c', 'Botiqu_n__c', 'Capacitaci_n_uso_de_extintores__c',
                                        'Capacitaci_n_primeros_auxilios__c', 'Capacitaci_n_trabajo_en_alturas__c', 'Control_diario_de_inventarios__c', 'Tabla_de_aforo__c', 'Permiso_de_vertimientos__c',
                                        'Mantenimiento_de_tanques__c', 'Prueba_de_calidad_fondo_del_tanque__c', 'Pruebas_en_el_surtidor__c', 'Calibraci_n_equipos_de_despacho__c', 'Calidad_prueba_fondo_del_tanque__c',
                                        'Cables_sueltos__c', 'Elementos_que_puedan_caer__c', 'Ter_Extintores_zona_des__c', 'Elementos_de_protecci_n_personal__c', 'Ter_Elementos_de_proteccion_alturas__c',
                                        'Sistema_de_protecci_n_contra_caidas__c', 'Ter_Comentarios_pilar_ambiental_Infraest__c', 'Ter_Califi_pilar_ambiental_infraestruct2__c', 'Ter_Comentarios_pilar_ambiental_Operacio__c',
                                        'Ter_Califi_pilar_ambiental_Operaci_n2__c', 'Ter_Comentarios_calidad_infraestructura__c', 'Ter_Calif_pilar_Calidad_infraestructu2__c', 'Ter_Comentarios_pilar_Calidad_Operacion__c',
                                        'Ter_Calif_pilar_Calidad_Operaci_n2__c', 'Ter_Comentarios_Pilar_Seguridad_infra__c', 'Ter_Calif_pilar_Seguridad_infraestruc2__c', 'Ter_Calif_pilar_Seguridad_operaci_n2__c',
                                        'Ter_Comentarios_Pila_Seguridad_Operacion__c', 'Ter_Calificacion_EDS__c', 'OwnerId', 'Owner.Name'};
        if(!test.isRunningTest())
            objStandardController.addFields( lstCampos );
        objActa = (Ter_Acta_Encuesta__c)objStandardController.getRecord();
        system.debug('objActa --> ' + objActa);
        lstEDS = [SELECT Id ,Name, Ter_Zona__c, Ter_Nombre_jefe_de_zona__r.Name, Ter_Nombre_jefe_de_zona__r.Email, Ter_Codigo_unico__c, 
                        (Select id, Subject, StartDateTime, whoId, who.Name from Events where Ter_Acta__c =: objActa.id), 
                        (Select Id, Name from Actas_Encuesta__r where id =: objActa.id) 
                    FROM Ter_Estacion_de_Servicio__c 
                    WHERE id =: objActa.Ter_Nombre_EDS__c];
        system.debug('lstEDS.size() --> ' + lstEDS.size());
        if(!lstEDS.isEmpty())
        {
            system.debug('lstEDS[0].Events --> ' + lstEDS[0].Events);
            system.debug('lstEDS[0].Actas_Encuesta__r --> ' + lstEDS[0].Actas_Encuesta__r);
            if(!lstEDS[0].Events.isEmpty())
            {
                system.debug('lstEDS[0].Events --> ' + lstEDS[0].Events);
                Integer intDia = lstEDS[0].Events[0].StartDateTime.day();
                Integer intMes = lstEDS[0].Events[0].StartDateTime.month();
                Integer intAno = lstEDS[0].Events[0].StartDateTime.year();
                Date datFechaVisita =  date.newInstance(intAno, intMes, intDia);
                strFechaVisita = string.valueOf(datFechaVisita);
                system.debug('datFechaVisita --> ' + datFechaVisita);
            
                set<Id> setIds = new set<Id>();
                
                lstEvenWho = [SELECT Id, RelationId, Relation.Name FROM EventWhoRelation WHERE EventId =: lstEDS[0].Events[0].id];
                for(EventWhoRelation objEventWho : lstEvenWho)
                {
                    setIds.add(objEventWho.RelationId);
                }
                
                if(test.isRunningTest())
                    setIds.add(lstEDS[0].Events[0].whoId);
                    
                lstContact = [select Name, Ter_Cargo__c, Email from Contact where id IN: setIds /*and Email != null*/];
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'La EDS del acta seleccionada no tiene ningún evento relacionado.'));
                blnMostrar = false;
            }
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'El acta seleccionada no tiene ninguna EDS relacionada.'));
            blnMostrar = false;
        }
    }
    
    public PageReference enviarCorreo()
    {
        list<string> lstEmails = new list<string>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        system.debug('lstContact --> ' + lstContact);
        if(!lstContact.isEmpty())
        {
            for(Contact objContact : lstContact)
            {
                if(objContact.Email != null)
                    lstEmails.add(objContact.Email);
            }
            system.debug('lstEmails --> ' + lstEmails);
            if(!lstEmails.isEmpty())
            {
                if(lstEDS[0].Ter_Nombre_jefe_de_zona__r.Email != null)
                {
                    lstEmails.add(lstEDS[0].Ter_Nombre_jefe_de_zona__r.Email);
                    system.debug('lstEmails + Jefe de Zona--> ' + lstEmails);
                    //Valida que los contactos asociados tengan correo al que se le pueda enviar el acta.
                    
                    String strAsunto = 'Acta Visita EDS';
                    Attachment att = new Attachment(name = strAsunto);
                    PageReference pagPDF = Page.Ter_GenerarPDF_pag;
                    pagPDF.getParameters().put('id',objActa.Id);
                    if(!Test.isRunningTest())
                        att.body = pagPDF.getContentAsPDF();
                    else
                        att.body = Blob.valueOf('Text');
                        Att.ContentType = 'application/pdf';
                    att.parentid = objActa.Id;
                    try
                    {
                        insert att;
                    }
                    catch(system.exception e)
                    {
                        system.debug('Error --> ' + e);
                        ApexPages.addMessages(e); 
                    }
                    
                    
                    
                    //Envio de todos los documentos adjunto en el registro.
                    /*list<Messaging.EmailFileAttachment> lstFileAtt = new list<Messaging.EmailFileAttachment>();
                    list<Attachment>lstAtt = [SELECT Id, Name, ParentId, ContentType, Body FROM Attachment WHERE ParentId =: objActa.Id];
                    list<String> lstString = new list<String>();
                    Messaging.EmailFileAttachment objEfa = new Messaging.EmailFileAttachment();
                    for(Attachment objAtt : lstAtt)
                    //{
                        //lstString = objAtt.ContentType.split('/');
                        //String strNombreArchivo = objAtt.Name;
                        //String strExtensionArchivo = strNombreArchivo.substringAfterLast('.');
                        //objEfa = new Messaging.EmailFileAttachment();
                        //objEfa.setFileName(objAtt.Name+'.'+lstString.get(1));
                        //objEfa.setFileName(objAtt.Name);
                        //objEfa.setBody(objAtt.body);
                        //lstFileAtt.add(objEfa);
                    //}
                    //System.debug('lstFileAtt --> ' + lstFileAtt);
                    email.setFileAttachments(lstFileAtt);*/
                    
                    
                    
                    Messaging.EmailFileAttachment objEfa = new Messaging.EmailFileAttachment();
                    objEfa.setFileName('Acta bitácora ambiental.pdf');
                    objEfa.setBody(att.body);
                    
                    EmailTemplate et = [SELECT id, HtmlValue FROM EmailTemplate WHERE developerName = 'Ter_Acta_Bitacora_ambiental'];
                    
                    mail.setSaveAsActivity(false);
                
                    mail.setToAddresses(lstEmails);
                    for(Contact objContact : lstContact)
                    {
                        if(objContact.Email != null)
                        {
                            mail.setTargetObjectId(objContact.Id);
                            break;
                        }
                    }
                    mail.setWhatId(objActa.Id);
                    mail.setTemplateId(et.id);
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[] {objEfa});
                    //mail.setFileAttachments(lstFileAtt);
                    //mail.setFileAttachments(new Messaging.EmailFileAttachment[] {lstFileAtt});
                    mails.add(mail);
                    Messaging.sendEmail(mails);
                    
                    System.debug('\n\n Correo enviado a '+lstEmails);
                    
                    Pagereference pr = new Pagereference( '/' + objActa.Id );
                    pr.setRedirect(true);
                    return pr;
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'El jefe de zona asociado a la EDS no tiene Correo Electrónico asociado.'));
                    return null;
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Los contactos y/o participantes registrados no tienen Correo Electrónico asociado.'));
                return null;
            }
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'El acta seleccionada no tiene contactos relacionados en el evento de la EDS.'));
            return null;
        }
        return null;
    }
    
    public pagereference regresar()
    {
        Pagereference pr = new Pagereference( '/' + objActa.Id );
        pr.setRedirect(true);
        return pr; 
    }
}