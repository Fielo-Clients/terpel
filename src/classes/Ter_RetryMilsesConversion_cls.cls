/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargado de Ejecutar la tarea de reintentos del servicio de conversion miles
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		30/05/2017		Cristian Mosquera (CM)		Implementacion inicial del cron.
**/
global class Ter_RetryMilsesConversion_cls implements Schedulable {

    /**
     * Metodo responsable de ejecutar la tarea en batch de reintentos de redencion.
     * @param sc contexto del programador de tareas.
     */
    global void execute(SchedulableContext sc) {
        retryInvokeService();
    }

    /**
     * Metodo responsable de realizar el reintento de la redencion.
     */
    public void retryInvokeService() {
        try {

            Ter_RetryMilsesConverBatch_cls objBatch = new Ter_RetryMilsesConverBatch_cls();
            ID batchprocessid = Database.executeBatch(objBatch, 50);
        }
        catch (Exception e) {
            System.debug('El Error -->' + e.getStackTraceString());
        }


    }
}