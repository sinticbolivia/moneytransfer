namespace SinticBolivia.Modules.MoneyTransfer.Classes
{
    public class GoogleAuth
    {
        public GoogleAuth()
        {

        }
        public void start()
        {
            string scope = "https://www.googleapis.com/auth/drive";
            string uri = "https://accounts.google.com/o/oauth2/auth?"+
                "response_type=code"+
                "&client_id=783554179767.apps.googleusercontent.com"+
                "&redirect_uri=urn:ietf:wg:oauth:2.0:oob"+
                @"&scope=$(scope)";
            
        }
    }
}
