public with sharing class Ter_MemberValidationResponse {
	
	public Body Body { get; set; }
	
	public class MemberValidationResponse
	{
	    public string response_code { get; set; }
	    public string log_sequence { get; set; }
	    public string apply_invoice { get; set; }
	    public string tax { get; set; }
	    public string country_code { get; set; }
	    public string email { get; set; }
	    public string state { get; set; }
	    public string city { get; set; }
	    public string member_account_date { get; set; }
	    public string member_tier { get; set; }
	    public string account_balance { get; set; }
	    public string last_name { get; set; }
	    public string first_name { get; set; }
	    public string member_id { get; set; }
	}
	
	public class Body
	{
	    public MemberValidationResponse MemberValidationResponse { get; set; }
	}
	
	public class RootObject
	{
	    public Body Body { get; set; }
	}
    
}