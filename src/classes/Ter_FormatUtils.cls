/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de implementar metodos utilitarios de formatos.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		30/05/2017		Cristian Mosquera (CM)		Implementacion inicial del util.
**/
public class Ter_FormatUtils {


    /**
     * Metodo que evalua si un string excede el numero maximo de caracteres.
     * @param str el valor del string.
     * @param maxChars numero maximo de caracteres.
     * @return <code>true</code> si es blanco o vacio <code>false</code> en caso contrario.
     */
    public static Boolean excededMaxCharacters(String str, Integer maxChars) {
        return str != null  && str.length() > maxChars;
    }

    /**
     * Metodo que evalua si un string cumple con una expresion regular.
     * @param regex la expresion a evaluar.
     * @param value el valor que se desea evalauar.
     * @return <code>true</code> si el valor coincide <code>false</code> en caso contrario.
     */
    public static boolean checkFormatByRegex(String regex, String value) {
        if (String.isBlank(value)) {
            return true;
        }
        Pattern regexPattern = Pattern.compile(regex);
        Matcher regexMatcher = regexPattern.matcher(value);
        return regexMatcher.matches();
    }


}