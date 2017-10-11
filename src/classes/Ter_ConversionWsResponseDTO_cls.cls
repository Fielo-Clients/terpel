/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de definir los atributos de transporte de datos para el response
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		30/05/2017		Cristian Mosquera (CM)		Implementacion inicial del DTO.
**/
public class Ter_ConversionWsResponseDTO_cls {

	/** Identificador de la transaccion Fromato YYYYMMDDHHMMSS000000.**/
    private String transactionId;
	/** Identificador de la trasaccion relacionado al original miles formato YYYYMMDDHHMMSS000000.**/
    private String transactionIdSource;
    /** El numero de autorizacion de lifemiles.**/
    private String authoNum;
    /** Identificador. de la cuenta miembro. **/
    private String memberId;
    /** Numero unico de miembro.**/
    private String lifeMilesNumber;
	/** El tipo de transaccion (Credit C, Reversion R, Pre-purchase P). **/
    private String transactionType;
	/** Identificador de la pre-compra (solo es usado en transacciondes de pre-compra). **/
    private String prepurchaseTrans;
	/** Cantidad de millas requeridas para la transaccion.**/
    private Decimal conversionMiles;
	/** Cantidad de bonificacion en millas reportada por el socio. **/
    private Decimal promotionalMiles;
	/** Cantidad de millas otorgadas al miembro. **/
    private Decimal bonusMiles;
    /** El codigo de respuesta. **/
    private String responseCode;

	/**
	 * Getter del atributo transactionId.
	 *
	 * @return el atributo transactionId.
	 */
    public String getTransactionId() {
        return transactionId;
    }
	/**
	 * Setter del atributo transactionId.
	 *
	 * @param transactionId el atributo transactionId a establecer.
	 */
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
	/**
	 * Getter del atributo transactionIdSource.
	 *
	 * @return el atributo transactionIdSource.
	 */
    public String getTransactionIdSource() {
        return transactionIdSource;
    }
	/**
	 * Setter del atributo transactionIdSource.
	 *
	 * @param transactionIdSource el atributo transactionIdSource a establecer.
	 */
    public void setTransactionIdSource(String transactionIdSource) {
        this.transactionIdSource = transactionIdSource;
    }

    /**
	 * Getter del atributo authoNum.
	 *
	 * @return el atributo authoNum.
	 */
    public String getAuthoNum() {
        return authoNum;
    }

	/**
	 * Setter del atributo authoNum.
	 *
	 * @param memberId el atributo authoNum a establecer.
	 */
    public void setAuthoNum(String authoNum) {
        this.authoNum = authoNum;
    }

    /**
	 * Getter del atributo memberId.
	 *
	 * @return el atributo memberId.
	 */
    public String getMemberId() {
        return memberId;
    }

	/**
	 * Setter del atributo memberId.
	 *
	 * @param memberId el atributo memberId a establecer.
	 */
    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

	/**
	 * Getter del atributo lifeMilesNumber.
	 *
	 * @return el atributo lifeMilesNumber.
	 */
    public String getLifeMilesNumber() {
        return lifeMilesNumber;
    }
	/**
	 * Setter del atributo lifeMilesNumber.
	 *
	 * @param lifeMilesNumber el atributo lifeMilesNumber a establecer.
	 */
    public void setLifeMilesNumber(String lifeMilesNumber) {
        this.lifeMilesNumber = lifeMilesNumber;
    }
	/**
	 * Getter del atributo transactionType.
	 *
	 * @return el atributo transactionType.
	 */
    public String getTransactionType() {
        return transactionType;
    }
	/**
	 * Setter del atributo transactionType.
	 *
	 * @param transactionType el atributo transactionType a establecer.
	 */
    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }
	/**
	 * Getter del atributo prepurchaseTrans.
	 *
	 * @return el atributo prepurchaseTrans.
	 */
    public String getPrepurchaseTrans() {
        return prepurchaseTrans;
    }
	/**
	 * Setter del atributo prepurchaseTrans.
	 *
	 * @param prepurchaseTrans el atributo prepurchaseTrans a establecer.
	 */
    public void setPrepurchaseTrans(String prepurchaseTrans) {
        this.prepurchaseTrans = prepurchaseTrans;
    }
	/**
	 * Getter del atributo conversionMiles.
	 *
	 * @return el atributo conversionMiles.
	 */
    public Decimal getConversionMiles() {
        return conversionMiles;
    }
	/**
	 * Setter del atributo conversionMiles.
	 *
	 * @param conversionMiles el atributo conversionMiles a establecer.
	 */
    public void setConversionMiles(Decimal conversionMiles) {
        this.conversionMiles = conversionMiles;
    }
	/**
	 * Getter del atributo promotionalMiles.
	 *
	 * @return el atributo promotionalMiles.
	 */
    public Decimal getPromotionalMiles() {
        return promotionalMiles;
    }
	/**
	 * Setter del atributo promotionalMiles.
	 *
	 * @param promotionalMiles el atributo promotionalMiles a establecer.
	 */
    public void setPromotionalMiles(Decimal promotionalMiles) {
        this.promotionalMiles = promotionalMiles;
    }
	/**
	 * Getter del atributo bonusMiles.
	 *
	 * @return el atributo bonusMiles.
	 */
    public Decimal getBonusMiles() {
        return bonusMiles;
    }
	/**
	 * Setter del atributo bonusMiles.
	 *
	 * @param bonusMiles el atributo bonusMiles a establecer.
	 */
    public void setBonusMiles(Decimal bonusMiles) {
        this.bonusMiles = bonusMiles;
    }
	/**
	 * Getter del atributo responseCode.
	 *
	 * @return el atributo responseCode.
	 */
    public String getResponseCode() {
        return responseCode;
    }
	/**
	 * Setter del atributo responseCode.
	 *
	 * @param responseCode el atributo responseCode a establecer.
	 */
    public void setResponseCode(String responseCode) {
        this.responseCode = responseCode;
    }

	/**
	 * Metodo encargado de obtener los valores de los atributos de la instancia de la clase.
	 * @return los valores de los atributos de la instancia de la clase.
	 */
    public override String toString() {
        return 'Ter_ConversionWsResponseDTO_cls [transactionId=' + transactionId + ', transactionIdSource='
        + transactionIdSource + ', memberId=' + memberId + ', lifeMilesNumber=' + lifeMilesNumber
        + ', transactionType=' + transactionType + ', prepurchaseTrans=' + prepurchaseTrans + ', responseCode='
        + responseCode + ']';
    }

}