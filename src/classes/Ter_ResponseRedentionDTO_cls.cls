/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de reprsentar la respuesta del webservice de redencion
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		20/06/2017		Cristian Mosquera (CM)		Implementacion inicial del DTO.
**/
public class Ter_ResponseRedentionDTO_cls {

    /** El cuerpo de la respuesta**/
    private Body body;

    /**
	 * Getter del atributo body.
	 *
	 * @return el atributo body.
	 */
    public Body getBody() {
        return body;
    }

	/**
	 * Setter del atributo body.
	 *
	 * @param body el atributo body a establecer.
	 */
    public void setBody(Body body) {
        this.body = body;
    }

    /**
     * Clase que define el body.
     */
    public class Body {

        /** Postea la respuesta.**/
        private PostingResponse postingResponse;

        /**
	     * Getter del atributo postingResponse.
	     *
	     * @return el atributo postingResponse.
	    */
        public PostingResponse getPostingResponse() {
            return postingResponse;
        }

	    /**
	     * Setter del atributo postingResponse.
	     *
	     * @param postingResponse el atributo postingResponse a establecer.
	     */
        public void setPostingResponse(PostingResponse postingResponse) {
            this.postingResponse = postingResponse;
        }
    }


    public class PostingResponse {

        /** Identificador de la transaccion.**/
        private String transaction_id;
        /** Identificador del miembro.**/
        private String member_id;
        /** Cantidad posteada.**/
        private integer posting_amount ;
        /** Codigo de socio.**/
        private String partner_code  ;
        /** Tipo de trasaccion.**/
        private String transaction_type   ;
        /** Log de sequencia..**/
        private long log_sequence;
        /** El codugo de respuesta.**/
        private String response_code;
        
        private integer discount_amount;
        
        private String session;
        
        private String autho_num;
        

    	/**
	    * Getter del atributo transaction_id.
	    *
	    * @return el atributo transaction_id.
	    */
        public String getTransaction_id() {
            return transaction_id;
        }

        /**
         * Setter del atributo transaction_id.
         *
         * @param transaction_id el atributo transaction_id a establecer.
         */
        public void setTransaction_id(String transaction_id) {
            this.transaction_id = transaction_id;
        }

        /**
         * Getter del atributo member_id.
         *
         * @return el atributo member_id.
         */
        public String getMember_id() {
            return member_id;
        }

        /**
         * Setter del atributo member_id.
         *
         * @param member_id el atributo member_id a establecer.
         */
        public void setMember_id(String member_id) {
            this.member_id = member_id;
        }

        /**
         * Getter del atributo posting_amount.
         *
         * @return el atributo posting_amount.
         */
        public integer getPosting_amount() {
            return posting_amount;
        }

        /**
         * Setter del atributo posting_amount.
         *
         * @param posting_amount el atributo posting_amount a establecer.
         */
        public void setPosting_amount(integer posting_amount) {
            this.posting_amount = posting_amount;
        }

        /**
         * Getter del atributo partner_code.
         *
         * @return el atributo partner_code.
         */
        public String getPartner_code() {
            return partner_code;
        }

        /**
         * Setter del atributo partner_code.
         *
         * @param partner_code el atributo partner_code a establecer.
         */
        public void setPartner_code(String partner_code) {
            this.partner_code = partner_code;
        }

        /**
         * Getter del atributo transaction_type.
         *
         * @return el atributo transaction_type.
         */
        public String getTransaction_type() {
            return transaction_type;
        }

        /**
         * Setter del atributo transaction_type.
         *
         * @param transaction_type el atributo transaction_type a establecer.
         */
        public void setTransaction_type(String transaction_type) {
            this.transaction_type = transaction_type;
        }

        /**
         * Getter del atributo log_sequence.
         *
         * @return el atributo log_sequence.
         */
        public long getLog_sequence() {
            return log_sequence;
        }

        /**
         * Setter del atributo log_sequence.
         *
         * @param log_sequence el atributo log_sequence a establecer.
         */
        public void setLog_sequence(long log_sequence) {
            this.log_sequence = log_sequence;
        }

        /**
         * Getter del atributo response_code.
         *
         * @return el atributo response_code.
         */
        public String getResponse_code() {
            return response_code;
        }

        /**
         * Setter del atributo response_code.
         *
         * @param response_code el atributo response_code a establecer.
         */
        public void setResponse_code(String response_code) {
            this.response_code = response_code;
        }
        
        /**
	    * Getter del atributo discount_amount.
	    *
	    * @return el atributo discount_amount.
	    */
        public integer getDiscount_amount(){
        	return this.discount_amount;
        }
        
        /**
         * Setter del atributo discount_amount.
         *
         * @param session el atributo discount_amount a establecer.
         */
        public void setDiscount_amount(integer discount_amount){
        	this.discount_amount = discount_amount;
        }
        
        
        /**
	    * Getter del atributo session.
	    *
	    * @return el atributo session.
	    */
        public String getSession(){
        	return this.session;
        }
        
        /**
         * Setter del session autho_num.
         *
         * @param session el atributo session a establecer.
         */
        public void setSession(String session){
        	this.session = session;
        }
        
        
        /**
	    * Getter del atributo autho_num.
	    *
	    * @return el atributo autho_num.
	    */
        public String getAutho_num(){
        	return this.autho_num;
        }
        
        /**
         * Setter del atributo autho_num.
         *
         * @param autho_num el atributo autho_num a establecer.
         */
        public void setAutho_num(String autho_num){
        	this.autho_num = autho_num;
        }

    }


}