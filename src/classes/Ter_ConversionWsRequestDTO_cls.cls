/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de definir los atributos de transporte de datos para el request
*                   de redencion.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		30/05/2017		Cristian Mosquera (CM)		Implementacion inicial del dto.
**/
public class Ter_ConversionWsRequestDTO_cls {
	
    /** Usiario de LifeMiles. **/
    private String username;
	/** Password de LifeMiles. **/
    private String password;
	/** Identificador de la transaccion Fromato YYYYMMDDHHMMSS000000.**/
    private String transactionId;
	/** Identificador de la trasaccion relacionado al original miles formato YYYYMMDDHHMMSS000000.**/
    private String transactionIdSource;
    /** Identificador. de la cuenta miembro. **/
    private String memberId;
    
	/** El tipo de transaccion (Credit C, Reversion R, Pre-purchase P). **/
    private String transactionType;
	/** Identificador de la pre-compra (solo es usado en transacciondes de pre-compra). **/
    private String prepurchaseTrans;
	/** Cantidad de millas requeridas para la transaccion.**/
    private Decimal conversionMiles;
	/** Cantidad de bonificacion en millas reportada por el socio. **/
    private Decimal promotionalMiles;
	/** El codigo del socio que solicita la conversion de millas. **/
    private String senderCode;
    /** El identificador de autorizacion de fielo. **/
    private String fieloAutorizacionLifeMilesId;
    /** La utileria de cifrado. **/
    private Ter_UtilEncriptacion_cls ter_utilEncriptacion_cls = new Ter_UtilEncriptacion_cls();

	/**
	 * Getter del atributo username.
	 *
	 * @return el atributo username.
	 */
    public String getUsername() {
        return username;
    }

	/**
	 * Setter del atributo username.
	 *
	 * @param username el atributo username a establecer.
	 */
    public void setUsername(String username) {
        this.username = username;
    }

	/**
	 * Getter del atributo password.
	 *
	 * @return el atributo password.
	 */
    public String getPassword() {
        return password;
    }

	/**
	 * Setter del atributo password.
	 *
	 * @param password el atributo password a establecer.
	 */
    public void setPassword(String password) {
        this.password = password;
    }

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
	 * Getter del atributo senderCode.
	 *
	 * @return el atributo senderCode.
	 */
    public String getSenderCode() {
        return senderCode;
    }

	/**
	 * Setter del atributo senderCode.
	 *
	 * @param senderCode el atributo sender_code a establecer.
	 */
    public void setSenderCode(String senderCode) {
        this.senderCode = senderCode;
    }

    /**
	 * Getter del atributo fieloAutorizacionLifeMilesId.
	 *
	 * @return el atributo fieloAutorizacionLifeMilesId.
	 */
    public String getFieloAutorizacionLifeMilesId() {
        return fieloAutorizacionLifeMilesId;
    }

	/**
	 * Setter del atributo fieloAutorizacionLifeMilesId.
	 *
	 * @param fieloAutorizacionLifeMilesId el atributo fieloAutorizacionLifeMilesId a establecer.
	 */
    public void setFieloAutorizacionLifeMilesId(String fieloAutorizacionLifeMilesId) {
        this.fieloAutorizacionLifeMilesId = fieloAutorizacionLifeMilesId;
    }

	/**
	 * Metodo encargado de obtener los valores de los atributos de la instancia de la clase.
	 * @return los valores de los atributos de la instancia de la clase.
	 */
    public override String toString() {
        return 'Ter_ConversionWsRequestDTO_cls [username=' + username + ', password=' + password + ', transactionId='
        + transactionId + ', transactionIdSource=' + transactionIdSource + ', memberId=' + memberId
        + ', transactionType=' + transactionType + ', prepurchaseTrans=' + prepurchaseTrans
        + ', conversionMiles=' + conversionMiles + ', promotionalMiles=' + promotionalMiles + ', senderCode='
        + senderCode + ', fieloAutorizacionLifeMilesId=' + fieloAutorizacionLifeMilesId + ']';
    }

}