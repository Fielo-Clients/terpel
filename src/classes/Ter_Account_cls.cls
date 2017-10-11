/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez (WRM)
Proyecto: Terpel
Descripción: Clase que se encargara de las validaciones y las creaciones sobre el objeto cuentas. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 23-01-2017  Walter Rodríguez M (WRM)      Creación de la Clase.
***********************************************************************************/

public class Ter_Account_cls 
{
    public Ter_Account_cls()
    {
        
    }
    
    public void validaCambioEstado( List<Account>lstOldAccount, List<Account>lstNewAccount )
    {
        if( lstOldAccount[0].Ter_Estado_de_cliente__c != lstNewAccount[0].Ter_Estado_de_cliente__c )
        {
            if( lstNewAccount[0].Ter_Estado_de_cliente__c == 'Visita' )
            {
                Integer intAcc = [ SELECT count() FROM Contact WHERE AccountId =: lstNewAccount[0].Id ];
                if(intAcc == 0)
                    lstNewAccount[0].Ter_Estado_de_cliente__c.addError('Error! Solo puede pasar a estado Visita si se tiene por lo menos un contacto asociado');
            }
            else if( lstNewAccount[0].Ter_Estado_de_cliente__c == 'Propuesta' )
            {
                Integer intTask = [ SELECT count() FROM Task WHERE AccountId =: lstNewAccount[0].Id ];
                Integer intEvent = [ SELECT count() FROM Event WHERE AccountId =: lstNewAccount[0].Id ];
                if(intTask == 0 && intEvent == 0)
                    lstNewAccount[0].Ter_Estado_de_cliente__c.addError('Error! Solo puede pasar a estado Propuesta si se tiene por lo menos una actividad asociada');
            }
            else if( lstNewAccount[0].Ter_Estado_de_cliente__c == 'Legalización' )
            {
                Integer intAtt = [ SELECT count() FROM Attachment WHERE ParentId =: lstNewAccount[0].Id ];
                system.debug('intAtt --> ' + intAtt);
                if(intAtt == 0)
                    lstNewAccount[0].Ter_Estado_de_cliente__c.addError('Error! Solo puede pasar a estado Legalización si se tiene por lo menos un documento adjunto');
            }
            else if( lstNewAccount[0].Ter_Estado_de_cliente__c == 'Legalizada' )
            {
                Integer intAtt = [ SELECT count() FROM Attachment WHERE ParentId =: lstNewAccount[0].Id ];
                if(intAtt <= 1)
                    lstNewAccount[0].Ter_Estado_de_cliente__c.addError('Error! Solo puede pasar a estado legalizado si se tiene por lo menos dos documentos adjuntos');
            }
        }
    }
}