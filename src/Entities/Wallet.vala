using SinticBolivia.Classes;
using SinticBolivia.Database;

namespace SinticBolivia.Modules.MoneyTransfer.Entities
{
    public class Wallet : Entity
    {
        public  long    id {get;set;}
        public  long    user_id {get;set;}
        public  double  amount {get;set; default = 0;}
        public  double  locked_amount {get;set;default = 0;}
        public  double  available_amount {get;set;default = 0;}

        construct
        {
            this._table = "mr_wallets";
            this._primary_key = "id";
        }
        public SBHasMany<WalletCharge> charges()
        {
            return this.has_many<WalletCharge>("wallet_id", "id");
        }
        public SBCollection<WalletCharge> get_charges()
        {
            return this.charges().get();
        }
    }
}
