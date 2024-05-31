using SinticBolivia.Database;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Entities
{
    public class RequestState : Entity
    {
        public  long    id {get;set;}
        public  long    request_id {get;set;}
        public  long    user_id {get;set;}
        public  string  old_status {get;set;}
        public  string  new_status {get;set;}
        public  string  notes {get;set;}
        public  string  deleted {get;set; default = "0";}

        construct
        {
            this._table = "mr_request_states";
            this._primary_key = "id";
        }
    }
}
