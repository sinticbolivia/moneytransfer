using SinticBolivia.Database;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Entities
{
    public class PaymentMethod : Entity
    {
        public  const       string  STATUS_ENABLED = "ENABLED";
        public  const       string  STATUS_DISABLED = "DISABLED";

        public  long        id {get;set;}
        public  long        user_id {get;set;}
        public  string      key {get;set;}
        public  string      name {get;set;}
        public  string      description {get;set;}
        public  string      status {get;set; default = STATUS_ENABLED;}

        construct
        {
            this._table         = "mr_payment_methods";
            this._primary_key   = "id";
        }

        public PaymentMethod()
        {

        }
    }
}
