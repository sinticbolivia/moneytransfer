using SinticBolivia.Database;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Entities
{
    public class VeriffSession : Entity
    {
        public  long    id {get;set;}
        public  long    user_id {get;set;}
        public  string  session_id {get;set;}
        public  string  url {get;set;}
        public  string  status {get;set;}
        public  string  session_token {get;set;}
        
        public VeriffSession()
        {

        }
    }
}
