/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de ejecutar  las pruebas unitarias de la clase Ter_FormatUtils
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		31/05/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase de prueba.
**/
@isTest
public class Ter_FormatUtils_tst {

    /**
     * Metodo encargado de probar la funcionalidad del metodo checkFormatByRegex;
     */
    @isTest
    private static void testCheckFormatByRegex() {

        System.assert(Ter_FormatUtils.checkFormatByRegex
                (Label.TER_TRANSACTION_ID_REGEX_FORMAT, '19871030105410000010'));
        System.assert(!Ter_FormatUtils.checkFormatByRegex
                (Label.TER_TRANSACTION_ID_REGEX_FORMAT, 'asa'));
    }

    /**
     * Metodo encargado de probar la funcionalidad del metodo excededMaxCharacters;
     */
    @isTest
    private static void testExcededMaxCharacters() {

        System.assert(Ter_FormatUtils.excededMaxCharacters('5445', 3));
        System.assert(!Ter_FormatUtils.excededMaxCharacters('5445', 4));
    }
}