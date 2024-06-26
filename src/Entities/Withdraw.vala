using SinticBolivia;
using SinticBolivia.Database;

namespace SinticBolivia.Modules.MoneyTransfer.Entities
{
    public class Withdraw : Entity
    {
        public const string STATUS_PENDING      = "PENDING";
        public const string STATUS_ACCEPTED     = "ACCEPTED";
        public const string STATUS_PROCESSING   = "PROCESSING";
        public const string STATUS_COMPLETED    = "COMPLETED";

        public  long        id {get;set;}
        public  long        user_id {get;set;}
        public  SBDateTime  withdraw_date {get;set;}
        public  double      amount {get;set;}
        public  string      status {get;set; default = STATUS_PENDING;}
        
        construct
        {
            this._table = "mr_withdrawals";
            this._primary_key = "id";
        }
    }
}
