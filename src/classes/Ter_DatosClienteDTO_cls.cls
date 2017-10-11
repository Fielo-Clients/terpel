/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase DTO para el transporte de datos de los clientes a registrar
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    18/05/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class Ter_DatosClienteDTO_cls {
	
	private String strNumeroLifeMiles;
	
	private String strFirstName;
	
	private String strSegundoNombre;
	
	private String strLastName;
	
	private String strSegundoApellido;
	
	private String strPersonBirthdate;
	
	private Date dtFechaNacimiento;
	
	private String strPersonEmail;
	
	private String strPersonHomePhone;
	
	private String strGenero;
	
	private String strPersonMailingPostalCode;
	
	private String strTipoDocumento;
	
	private String strPaisDocumento;
	
	private String strNumeroIdentificacion;
	
	private String strLanguage;
	
	private String strPersonMailingStreet;
	
	private String strPersonMailingCountry;
	
	private String strPersonMailingState;
	
	private String strPersonMailingCity;
	
	private String strClubTerpelAgreementAccepted;
	
	private Boolean blnClubTerpelAgreementAccepted;
	
	private String strClubTerpelAgreementDate;
	
	private Date dtClubTerpelAgreementDate;
	
	private String strSessionId;
	
	private String strBalanceLifeMiles;
	
	private String strErrorCode;
	
	private String strSolicitudTarjetaLM;

	/**
	* Sobreescritura del metodo toString
	*/
	public override String toString() {
		return 'Ter_DatosClienteDTO_cls [strNumeroLifeMiles=' + strNumeroLifeMiles + ', strFirstName=' + strFirstName
				+ ', strSegundoNombre=' + strSegundoNombre + ', strLastName=' + strLastName + ', strSegundoApellido='
				+ strSegundoApellido + ', strPersonBirthdate=' + strPersonBirthdate + ', strPersonEmail='
				+ strPersonEmail + ', strPersonHomePhone=' + strPersonHomePhone + ', strGenero=' + strGenero
				+ ', strPersonMailingPostalCode=' + strPersonMailingPostalCode + ', strTipoDocumento='
				+ strTipoDocumento + ', strPaisDocumento=' + strPaisDocumento + ', strNumeroIdentificacion='
				+ strNumeroIdentificacion + ', strLanguage=' + strLanguage + ', strPersonMailingStreet='
				+ strPersonMailingStreet + ', strPersonMailingCountry=' + strPersonMailingCountry
				+ ', strPersonMailingState=' + strPersonMailingState + ', strPersonMailingCity=' + strPersonMailingCity
				+ ', strClubTerpelAgreementAccepted=' + strClubTerpelAgreementAccepted + ', strClubTerpelAgreementDate='
				+ strClubTerpelAgreementDate + ', strSessionId=' + strSessionId + ', strBalanceLifeMiles='
				+ strBalanceLifeMiles + ', strErrorCode=' + strErrorCode + ', strSolicitudTarjetaLM=' + strSolicitudTarjetaLM +  ']';
	}

	/**
	 * @return the strNumeroLifeMiles
	 */
	public String getStrNumeroLifeMiles() {
		return strNumeroLifeMiles;
	}

	/**
	 * @param strNumeroLifeMiles the strNumeroLifeMiles to set
	 */
	public void setStrNumeroLifeMiles(String strNumeroLifeMiles) {
		this.strNumeroLifeMiles = strNumeroLifeMiles;
	}

	/**
	 * @return the strFirstName
	 */
	public String getStrFirstName() {
		return strFirstName;
	}

	/**
	 * @param strFirstName the strFirstName to set
	 */
	public void setStrFirstName(String strFirstName) {
		this.strFirstName = strFirstName;
	}

	/**
	 * @return the strSegundoNombre
	 */
	public String getStrSegundoNombre() {
		return strSegundoNombre;
	}

	/**
	 * @param strSegundoNombre the strSegundoNombre to set
	 */
	public void setStrSegundoNombre(String strSegundoNombre) {
		this.strSegundoNombre = strSegundoNombre;
	}

	/**
	 * @return the strLastName
	 */
	public String getStrLastName() {
		return strLastName;
	}

	/**
	 * @param strLastName the strLastName to set
	 */
	public void setStrLastName(String strLastName) {
		this.strLastName = strLastName;
	}

	/**
	 * @return the strSegundoApellido
	 */
	public String getStrSegundoApellido() {
		return strSegundoApellido;
	}

	/**
	 * @param strSegundoApellido the strSegundoApellido to set
	 */
	public void setStrSegundoApellido(String strSegundoApellido) {
		this.strSegundoApellido = strSegundoApellido;
	}

	/**
	 * @return the strPersonBirthdate
	 */
	public String getStrPersonBirthdate() {
		return strPersonBirthdate;
	}
	
	/**
	 * @param dtFechaNacimiento the dtFechaNacimiento to set
	 */
	public void setDtFechaNacimiento(Date dtFechaNacimiento) {
		this.dtFechaNacimiento = dtFechaNacimiento;
	}
	
	/**
	 * @return the dtFechaNacimiento
	 */
	public Date getDtFechaNacimiento() {
		return dtFechaNacimiento;
	}

	/**
	 * @param strPersonBirthdate the strPersonBirthdate to set
	 */
	public void setStrPersonBirthdate(String strPersonBirthdate) {
		this.strPersonBirthdate = strPersonBirthdate;
	}

	/**
	 * @return the strPersonEmail
	 */
	public String getStrPersonEmail() {
		return strPersonEmail;
	}

	/**
	 * @param strPersonEmail the strPersonEmail to set
	 */
	public void setStrPersonEmail(String strPersonEmail) {
		this.strPersonEmail = strPersonEmail;
	}

	/**
	 * @return the strPersonHomePhone
	 */
	public String getStrPersonHomePhone() {
		return strPersonHomePhone;
	}

	/**
	 * @param strPersonHomePhone the strPersonHomePhone to set
	 */
	public void setStrPersonHomePhone(String strPersonHomePhone) {
		this.strPersonHomePhone = strPersonHomePhone;
	}

	/**
	 * @return the strGenero
	 */
	public String getStrGenero() {
		return strGenero;
	}

	/**
	 * @param strGenero the strGenero to set
	 */
	public void setStrGenero(String strGenero) {
		this.strGenero = strGenero;
	}

	/**
	 * @return the strPersonMailingPostalCode
	 */
	public String getStrPersonMailingPostalCode() {
		return strPersonMailingPostalCode;
	}

	/**
	 * @param strPersonMailingPostalCode the strPersonMailingPostalCode to set
	 */
	public void setStrPersonMailingPostalCode(String strPersonMailingPostalCode) {
		this.strPersonMailingPostalCode = strPersonMailingPostalCode;
	}

	/**
	 * @return the strTipoDocumento
	 */
	public String getStrTipoDocumento() {
		return strTipoDocumento;
	}

	/**
	 * @param strTipoDocumento the strTipoDocumento to set
	 */
	public void setStrTipoDocumento(String strTipoDocumento) {
		this.strTipoDocumento = strTipoDocumento;
	}

	/**
	 * @return the strPaisDocumento
	 */
	public String getStrPaisDocumento() {
		return strPaisDocumento;
	}

	/**
	 * @param strPaisDocumento the strPaisDocumento to set
	 */
	public void setStrPaisDocumento(String strPaisDocumento) {
		this.strPaisDocumento = strPaisDocumento;
	}

	/**
	 * @return the strNumeroIdentificacion
	 */
	public String getStrNumeroIdentificacion() {
		return strNumeroIdentificacion;
	}

	/**
	 * @param strNumeroIdentificacion the strNumeroIdentificacion to set
	 */
	public void setStrNumeroIdentificacion(String strNumeroIdentificacion) {
		this.strNumeroIdentificacion = strNumeroIdentificacion;
	}

	/**
	 * @return the strLanguage
	 */
	public String getStrLanguage() {
		return strLanguage;
	}

	/**
	 * @param strLanguage the strLanguage to set
	 */
	public void setStrLanguage(String strLanguage) {
		this.strLanguage = strLanguage;
	}

	/**
	 * @return the strPersonMailingStreet
	 */
	public String getStrPersonMailingStreet() {
		return strPersonMailingStreet;
	}

	/**
	 * @param strPersonMailingStreet the strPersonMailingStreet to set
	 */
	public void setStrPersonMailingStreet(String strPersonMailingStreet) {
		this.strPersonMailingStreet = strPersonMailingStreet;
	}

	/**
	 * @return the strPersonMailingCountry
	 */
	public String getStrPersonMailingCountry() {
		return strPersonMailingCountry;
	}

	/**
	 * @param strPersonMailingCountry the strPersonMailingCountry to set
	 */
	public void setStrPersonMailingCountry(String strPersonMailingCountry) {
		this.strPersonMailingCountry = strPersonMailingCountry;
	}

	/**
	 * @return the strPersonMailingState
	 */
	public String getStrPersonMailingState() {
		return strPersonMailingState;
	}

	/**
	 * @param strPersonMailingState the strPersonMailingState to set
	 */
	public void setStrPersonMailingState(String strPersonMailingState) {
		this.strPersonMailingState = strPersonMailingState;
	}

	/**
	 * @return the strPersonMailingCity
	 */
	public String getStrPersonMailingCity() {
		return strPersonMailingCity;
	}

	/**
	 * @param strPersonMailingCity the strPersonMailingCity to set
	 */
	public void setStrPersonMailingCity(String strPersonMailingCity) {
		this.strPersonMailingCity = strPersonMailingCity;
	}

	/**
	 * @return the strClubTerpelAgreementAccepted
	 */
	public String getStrClubTerpelAgreementAccepted() {
		return strClubTerpelAgreementAccepted;
	}

	/**
	 * @param strClubTerpelAgreementAccepted the strClubTerpelAgreementAccepted to set
	 */
	public void setStrClubTerpelAgreementAccepted(String strClubTerpelAgreementAccepted) {
		this.strClubTerpelAgreementAccepted = strClubTerpelAgreementAccepted;
	}
	
	/**
	 * @return the blnClubTerpelAgreementAccepted
	 */
	public Boolean isBlnClubTerpelAgreementAccepted() {
		return blnClubTerpelAgreementAccepted;
	}

	/**
	 * @param blnClubTerpelAgreementAccepted the blnClubTerpelAgreementAccepted to set
	 */
	public void setBlnClubTerpelAgreementAccepted(Boolean blnClubTerpelAgreementAccepted) {
		this.blnClubTerpelAgreementAccepted = blnClubTerpelAgreementAccepted;
	}

	/**
	 * @return the strClubTerpelAgreementDate
	 */
	public String getStrClubTerpelAgreementDate() {
		return strClubTerpelAgreementDate;
	}

	/**
	 * @param strClubTerpelAgreementDate the strClubTerpelAgreementDate to set
	 */
	public void setStrClubTerpelAgreementDate(String strClubTerpelAgreementDate) {
		this.strClubTerpelAgreementDate = strClubTerpelAgreementDate;
	}
	
	/**
	 * @param dtClubTerpelAgreementDate the dtClubTerpelAgreementDate to set
	 */
	public void setDtClubTerpelAgreementDate(Date dtClubTerpelAgreementDate) {
		this.dtClubTerpelAgreementDate = dtClubTerpelAgreementDate;
	}
	
	/**
	 * @return the dtClubTerpelAgreementDate
	 */
	public Date getDtClubTerpelAgreementDate() {
		return dtClubTerpelAgreementDate;
	}

	/**
	 * @return the strSessionId
	 */
	public String getStrSessionId() {
		return strSessionId;
	}

	/**
	 * @param strSessionId the strSessionId to set
	 */
	public void setStrSessionId(String strSessionId) {
		this.strSessionId = strSessionId;
	}

	/**
	 * @return the strBalanceLifeMiles
	 */
	public String getStrBalanceLifeMiles() {
		return strBalanceLifeMiles;
	}

	/**
	 * @param strBalanceLifeMiles the strBalanceLifeMiles to set
	 */
	public void setStrBalanceLifeMiles(String strBalanceLifeMiles) {
		this.strBalanceLifeMiles = strBalanceLifeMiles;
	}

	/**
	 * @return the strErrorCode
	 */
	public String getStrErrorCode() {
		return strErrorCode;
	}

	/**
	 * @param strErrorCode the strErrorCode to set
	 */
	public void setStrErrorCode(String strErrorCode) {
		this.strErrorCode = strErrorCode;
	}

	/**
	 * @return the strSolicitudTarjetaLM
	 */
	public String getStrSolicitudTarjetaLM() {
		return strSolicitudTarjetaLM;
	}

	/**
	 * @param strSolicitudTarjetaLM the strSolicitudTarjetaLM to set
	 */
	public void setStrSolicitudTarjetaLM(String strSolicitudTarjetaLM) {
		this.strSolicitudTarjetaLM = strSolicitudTarjetaLM;
	}
    
}