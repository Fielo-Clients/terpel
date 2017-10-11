global with sharing class Widget1API implements FieloCMS.ViewInterface{

    public List<LocationWrapper> fLocation { get; set; }
    public String fIdEstacion { get; set; } 
    public String fEstacionDetail { get; set; } 

    public String fLocationJson { 
        get {

            if(fLocation != null && fLocation.size() > 0) {

                return JSON.serialize(fLocation);
            }
            else {
                return '';
            }
        }
        set;
    }

    public Widget1API() {

        fLocation = new List<LocationWrapper>();

        Set<Id> lEstacionSet = new Set<Id>();
        for(Ter_Estacion_de_Servicio__c es :[SELECT Name, Ter_Latitud__c, Ter_Longitud__c, Ter_Direccion__c, Ter_Ciudad__c
                                             FROM Ter_Estacion_de_Servicio__c
                                             WHERE Ter_Estatus__c = 'Activa'
                                             AND Ter_Segmento__c != 'COMPETENCIA'
                                             AND Ter_Marca__c = 'Terpel'
                                             AND F_ClubTerpel__c = TRUE
                                             AND ( Ter_Latitud__c != NULL OR Ter_Longitud__c != NULL )
                                             ]) {

            lEstacionSet.add(es.id);
            fLocation.add(new LocationWrapper(es.id, es.Name, es.Ter_Latitud__c, es.Ter_Longitud__c, es.Ter_Direccion__c, es.Ter_Ciudad__c));
        }

        Map<Id,Id> lAnexosMap = new Map<Id,Id>();
        for(Attachment att :[SELECT Id FROM Attachment WHERE ParentId IN :lEstacionSet]) {

            lAnexosMap.put(att.ParentId, att.id);
        }

        for(LocationWrapper lc :fLocation) {

            // Utiliza o campo estacionId para armazenar o id da estação, após isto
            // atuliza o campo para o id do anexo ou seta como null se não tive anexo
            Id lIdAux = lAnexosMap.get(lc.estacionId);
            if(lIdAux != null) {
                lc.estacionId = lIdAux;
            }
            else {
                lc.estacionId = null;
            }
        }

    }

    global ApexPages.Component getComponent(FieloCMS__Component__c c){                
        Component.Widget1 mapa = new Component.Widget1(config=c);

        return mapa;        
    }

    public class LocationWrapper {

        String estacionId { get; set; }
        String name { get; set; }
        Decimal latitude { get; set; }
        Decimal longitude { get; set; }
        String address { get; set; }
        String city { get; set; }

        public LocationWrapper(String aEstacionId, String aName, Decimal aLat, Decimal aLong, String aAddress, String aCity) {
            this.estacionId = aEstacionId;
            this.name = aName;
            this.latitude = aLat;
            this.longitude = aLong;
            this.address = aAddress;
            this.city = aCity;
        }
    }

    webService static String estacionDetail(String aEstacionId) {

        List<Ter_Estacion_de_Servicio__c> lEstacionLst = [
            SELECT Name, Ter_Latitud__c, Ter_Longitud__c, Ter_Direccion__c, Ter_Ciudad__c 
            FROM Ter_Estacion_de_Servicio__c
            WHERE id = :aEstacionId];

        if(lEstacionLst.size() == 0) {
            return '';
        }
        else {
            String fURLAttachment;
            List<Attachment> lAnexos = [SELECT Id FROM Attachment WHERE ParentId = :lEstacionLst[0].Id];
            if (!lAnexos.isEmpty()) {
              String lURL = ProgramService.getProgramByDomain().SiteURL__c;
              if ( lURL != null )
              {
                String[] lParts = lURL.split('/'); 
                if(lParts.size() > 1) {
                    lURL = '/' + lParts[ lParts.size()-1 ];
                }
                else {
                    lURL = '';
                }
                
              }
                fURLAttachment = lURL + '/servlet/servlet.FileDownload?file=' + lAnexos.get(0).id;
                //corpoRegulamento = EncodingUtil.base64Encode(lAnexos.get(0).Body);
            } 

            String lResult = '<div id="content">' +
                '<div id="siteNotice">' +
                '</div>' +
                '<h1 id="firstHeading" class="firstHeading">' + lEstacionLst[0].Name + '</h1>' +
                '<div id="bodyContent">' +
                '<p><b>Estación: ' + lEstacionLst[0].Name + '</b>.</p>';

            if(String.isNotEmpty(fURLAttachment)) {

                lResult += '<p>Image: <apex:image url="' + fURLAttachment + '"/></p>';
            }
                
            lResult += '</div></div>';

            return lResult;
        }
    }
}