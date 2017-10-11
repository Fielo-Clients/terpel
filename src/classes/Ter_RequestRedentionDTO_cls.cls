/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de representar la peticion al websevice de redencion
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		16/06/2017		Cristian Mosquera (CM)		Implementacion inicial del DTO.
**/
public class Ter_RequestRedentionDTO_cls {

    /** El identificador de la transacion.**/
    private String transactionId;
    /** El identificador del miembro.**/
    private String memberId;
    /** La session generada.**/
    private String session;
    /** Cantidad de millas que desea redimir de la transacion.**/
    private String postingAmount;
    /** Cantidad de millas equivalente en millas.**/
    private String postingEquivalent;
    /** Codigo de socio.**/
    private String partnerCode;
    /** El tipo de transaccion (Credit, Debit, Reversion).**/
    private String transactionType;
    /** Fecha de la transaccion.**/
    private String transactionDate;
     /** Descripcion de la transaccion.**/
    private String transactionDesc;
     /** Usuario lifemiles.**/
    private String username;
    /** clave lifemiles para header.**/
    private String password;
     /** clave lifemiles.**/
    private String password2;
    /** Identificador de la trasaccion relacionado al original miles .**/
    private String transactionIdSource;
    /** Cantidad a descontar.**/
    private String discountAmount;
    /** El pin.**/
    private String pin;
    /** Lista de premios.**/
    private List<AwardDTO> awards = new List<AwardDTO>();



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
	 * Getter del atributo session.
	 *
	 * @return el atributo session.
	 */
    public String getSession() {
        return session;
    }

	/**
	 * Setter del atributo session.
	 *
	 * @param session el atributo session a establecer.
	 */
    public void setSession(String session) {
        this.session = session;
    }

	/**
	 * Getter del atributo postingAmount.
	 *
	 * @return el atributo postingAmount.
	 */
    public String getPostingAmount() {
        return postingAmount;
    }

	/**
	 * Setter del atributo postingAmount.
	 *
	 * @param postingAmount el atributo postingAmount a establecer.
	 */
    public void setPostingAmount(String postingAmount) {
        this.postingAmount = postingAmount;
    }

	/**
	 * Getter del atributo postingEquivalent.
	 *
	 * @return el atributo postingEquivalent.
	 */
    public String getPostingEquivalent() {
        return postingEquivalent;
    }

	/**
	 * Setter del atributo postingEquivalent.
	 *
	 * @param postingEquivalent el atributo postingEquivalent a establecer.
	 */
    public void setPostingEquivalent(String postingEquivalent) {
        this.postingEquivalent = postingEquivalent;
    }

	/**
	 * Getter del atributo partnerCode.
	 *
	 * @return el atributo partnerCode.
	 */
    public String getPartnerCode() {
        return partnerCode;
    }

	/**
	 * Setter del atributo partnerCode.
	 *
	 * @param partnerCode el atributo partnerCode a establecer.
	 */
    public void setPartnerCode(String partnerCode) {
        this.partnerCode = partnerCode;
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
	 * Getter del atributo transactionDate.
	 *
	 * @return el atributo transactionDate.
	 */
    public String getTransactionDate() {
        return transactionDate;
    }

	/**
	 * Setter del atributo transactionDate.
	 *
	 * @param transactionDate el atributo transactionDate a establecer.
	 */
    public void setTransactionDate(String transactionDate) {
        this.transactionDate = transactionDate;
    }

	/**
	 * Getter del atributo transactionDesc.
	 *
	 * @return el atributo transactionDesc.
	 */
    public String getTransactionDesc() {
        return transactionDesc;
    }

	/**
	 * Setter del atributo transactionDesc.
	 *
	 * @param transactionDesc el atributo transactionDesc a establecer.
	 */
    public void setTransactionDesc(String transactionDesc) {
        this.transactionDesc = transactionDesc;
    }

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
	 * Getter del atributo password2.
	 *
	 * @return el atributo password2.
	 */
    public String getPassword2() {
        return password2;
    }

	/**
	 * Setter del atributo password2.
	 *
	 * @param password2 el atributo password2 a establecer.
	 */
    public void setPassword2(String password2) {
        this.password2 = password2;
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
	 * Getter del atributo discountAmount.
	 *
	 * @return el atributo discountAmount.
	 */
    public String getDiscountAmount() {
        return discountAmount;
    }

	/**
	 * Setter del atributo discountAmount.
	 *
	 * @param discountAmount el atributo discountAmount a establecer.
	 */
    public void setDiscountAmount(String discountAmount) {
        this.discountAmount = discountAmount;
    }

	/**
	 * Getter del atributo awards.
	 *
	 * @return el atributo awards.
	 */
    public List<AwardDTO> getAwards() {
        return awards;
    }

	/**
	 * Setter del atributo awards.
	 *
	 * @param awards el atributo awards a establecer.
	 */
    public void setAwards(List<AwardDTO> awards) {
        this.awards = awards;
    }

    /**
	 * Getter del atributo pin.
	 *
	 * @return el atributo pin.
	 */
    public String getPin() {
        return pin;
    }

	/**
	 * Setter del atributo pin.
	 *
	 * @param pin el atributo pin a establecer.
	 */
    public void setPin(String pin) {
        this.pin = pin;
    }

    /**
     * Clase que representa los premios.
     */
    public class AwardDTO {

        /** Codigo de premio.**/
        private String awardCode;
        /** Nombre de premio.**/
        private String awardName;
        /** Detalle de premio.**/
        private String awardDetail;

        /**
	     * Getter del atributo awardCode.
	    *
	    * @return el atributo awardCode.
	     */
        public String getAwardCode() {
            return awardCode;
        }

        /**
         * Setter del atributo awardCode.
         *
         * @param awardCode el atributo awardCode a establecer.
         */
        public void setAwardCode(String awardCode) {
            this.awardCode = awardCode;
        }

        /**
         * Getter del atributo awardName.
         *
         * @return el atributo awardName.
         */
        public String getAwardName() {
            return awardName;
        }

        /**
         * Setter del atributo awardName.
         *
         * @param awardName el atributo awardName a establecer.
         */
        public void setAwardName(String awardName) {
            this.awardName = awardName;
        }

        /**
         * Getter del atributo awardDetail.
         *
         * @return el atributo awardDetail.
         */
        public String getAwardDetail() {
            return awardDetail;
        }

        /**
         * Setter del atributo awardDetail.
         *
         * @param awardDetail el atributo awardDetail a establecer.
         */
        public void setAwardDetail(String awardDetail) {
            this.awardDetail = awardDetail;
        }
    }

}