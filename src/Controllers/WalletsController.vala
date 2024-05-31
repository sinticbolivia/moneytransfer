using GLib;
using SinticBolivia.Classes;
using SinticBolivia.Database;
using SinticBolivia.Modules.MoneyTransfer.Entities;
using SinticBolivia.Modules.MoneyTransfer.Models;
using SinticBolivia.Modules.MoneyTransfer.Dto;
using SinticBolivia.Modules.MoneyTransfer.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Controllers
{
    public class WalletsController : BaseController
    {
        protected   WalletsModel    model;

        construct
        {
            this.model = new WalletsModel();
        }
        public override void register_routes()
        {
            this.add_route("GET", """/api/moneytransfer/wallets/(?P<id>\d+)/?$""", this.read)
                .set_protected(true);
            this.add_route("GET", """/api/moneytransfer/wallets/users/(?P<id>\d+)/?$""", this.read_user_wallet)
                .set_protected(true);
            this.add_route("GET", """/api/moneytransfer/wallets/(?P<id>\d+)/charges/?$""", this.read_charges)
                .set_protected(true);
            this.add_route("GET", """/api/moneytransfer/wallets/balance/?$""", this.read_balance)
                .set_protected(true);
        }
        public RestResponse? read_user_wallet(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("Identificador de usuario invalido");
                var wallet = Entity.where("user_id", "=", id).first<Wallet>();
                if( wallet == null && this.profile.can("mt.create_wallet") )
                {
                    wallet = new Wallet()
                    {
                        user_id = this.profile.user_id
                    };
                    wallet.save();
                }
                if( wallet == null )
                    throw new SBException.GENERAL("El usuario no tiene una billetera asignada");
                return new RestResponse(Soup.Status.OK, wallet.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("El identificador de billetera es invalido");
                var wallet = Entity.read<Wallet>(id);
                if( wallet == null )
                    throw new SBException.GENERAL("La billetera no existe");
                return new RestResponse(Soup.Status.OK, wallet.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read_charges(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("El identificador de billetera es invalido");
                var wallet = Entity.read<Wallet>(id);
                if( wallet == null )
                    throw new SBException.GENERAL("La billetera no existe");
                return new RestResponse(Soup.Status.OK, wallet.get_charges().to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read_balance(SBCallbackArgs args)
        {
            try
            {
                if( this.profile.user_id <= 0 )
                    throw new SBException.GENERAL("El identificador de billetera es invalido");
                var wallet = this.model.read_user_wallet(this.profile.user_id);
                return new RestResponse(Soup.Status.OK, wallet.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
    }
}
