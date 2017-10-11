public with sharing class Ter_SecurityTokenValidationResponse {
	
	public Body Body { get; set; }
	
	public class SecurityTokenValidationResponse
	{
	    public string response_code { get; set; }
	    public string session { get; set; }
	    public string token { get; set; }
	}
	
	public class Body
	{
	    public SecurityTokenValidationResponse SecurityTokenValidationResponse { get; set; }
	}
	
	public class RootObject
	{
	    public Body Body { get; set; }
	}
    
}