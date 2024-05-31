using SinticBolivia.Database;

namespace SinticBolivia.Modules.MoneyTransfer.Entities
{
    public class WalletCharge : Entity
    {
        public  long    id {get;set;}
        public  long    wallet_id {get;set;}
        public  long    request_id {get;set;}
        public  double  amount {get;set;}
        public  double  fee {get;set; default = 0;}
        public  double  charged_amount {get;set;}

        construct
        {
            this._table = "mr_wallet_charges";
            this._primary_key = "id";
        }
    }
}
