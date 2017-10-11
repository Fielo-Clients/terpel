/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargado de Convertir  de xml a json
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		20/06/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
global class Ter_XmlToJson_cls {
    public String xmlText { get; set; }
    public String getJsonText() {
        try {
            return parseDocumentToJson(xmlText);
        } catch (Exception e) {
            return '';
        }
    }

    //  Try to determine some data types by pattern
    static Pattern
            boolPat = Pattern.compile('^(true|false)$');//,
            //decPat = Pattern.compile('^[-+]?\\d+(\\.\\d+)?$'),
            //datePat = Pattern.compile('^\\d{4}.\\d{2}.\\d{2}$'),
            //timePat = Pattern.compile('^\\d{4}.\\d{2}.\\d{2} (\\d{2}:\\d{2}:\\d{2} ([-+]\\d{2}:\\d{2})?)?$'
           // );
    //  Primary function to decode XML
    static Map<Object, Object> parseNode(Dom.XmlNode node, Map<Object, Object> parent) {
        //  Iterate over all child elements for a given node
        for (Dom.XmlNode child: node.getChildElements()) {
            //  Pull out some information
            String nodeText = child.getText().trim(), name = child.getName();
            //  Determine data type
            Object value =
                    //  Nothing
                    String.isBlank(nodeText) ? null :
                            //  Try boolean
                            boolPat.matcher(nodeText).find() ?
                                    (Object) Boolean.valueOf(nodeText) :
                                    //  Try decimals
                                   // decPat.matcher(nodeText).find() ?
                                           // (Object) Decimal.valueOf(nodeText) :
                                            //  Try dates
                                            //datePat.matcher(nodeText).find() ?
                                             //       (Object) Date.valueOf(nodeText) :
                                                    //  Try times
                                               //     timePat.matcher(nodeText).find() ?
                                                          //  (Object) DateTime.valueOf(nodeText) :
                                                            //  Give up, use plain text
                                                            (Object) nodeText;
            //  We have some text to process
            if (value != null) {
                //  This is a pluralized word, make list
                if (name.endsWith('s')) {
                    // Add a new list if none exists
                    if (!parent.containsKey(name)) {
                        parent.put(name, new List<Object>());
                    }
                    // Add the value to the list
                    ((List<Object>) parent.get(name)).add(value);
                } else {
                    //  Store a new value
                    parent.put(name, value);
                }
            } else if (child.getNodeType() == Dom.XmlNodeType.ELEMENT) {
                //  If it's not a comment or text, we will recursively process the data
                Map<Object, Object> temp = parseNode(child, new Map<Object, Object>());
                //  If at least one node was processed, add a new element into the array
                if (!temp.isEmpty()) {
                    //  Again, create or update a list
                    if (parent.containsKey(name)) {
                        try {
                            //  If it's already a list, add it
                            ((List<Object>) parent.get(name)).add(temp);
                        } catch (Exception e) {
                            //  Otherwise, convert the element into a list
                            parent.put(name, new List<Object>{
                                    parent.get(name), temp
                            });
                        }
                    } else {
                        //  New element
                        parent.put(name, temp);
                    }
                }
            }
        }
        return parent;
    }
    //  This function converts XML into a Map
    global static Map<Object, Object> parseDocumentToMap(Dom.Document doc) {
        return parseNode(doc.getRootElement(), new Map<Object, Object>());
    }
    //  This function converts XML into a JSON string
    global static String parseDocumentToJson(String doc) {
        Dom.Document document = new Dom.Document();
        document.load(doc);
        return JSON.serializePretty(parseDocumentToMap(document));
    }
    //  This function converts XML into a native object
    //  If arrays are expected, but not converted automatically, this call may fail
    //  If so, use the parseDocumentToMap function instead and fix any problems
    global static Object parseDocumentToObject(String doc, Type klass) {
        Dom.Document document = new Dom.Document();
        document.load(doc);
        return JSON.deserialize(parseDocumentToJson(doc), klass);
    }
}