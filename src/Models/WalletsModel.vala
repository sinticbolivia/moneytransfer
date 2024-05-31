using SinticBolivia;
using SinticBolivia.Classes;
using SinticBolivia.Database;
using SinticBolivia.Modules.MoneyTransfer.Entities;

namespace SinticBolivia.Modules.MoneyTransfer.Models
{
    public class WalletsModel
    {
        public WalletsModel()
        {

        }
        public Wallet read_user_wallet(long id)
        {
            var wallet = Entity.where("user_id", "=", id).first<Wallet>();
            if( wallet == null /*&& this.profile.can("mt.create_wallet")*/ )
            {
                wallet = new Wallet()
                {
                    user_id = id
                };
                wallet.save();
            }
            return wallet;
        }
    }
}
