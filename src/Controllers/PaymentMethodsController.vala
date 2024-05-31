using Gee;
using SinticBolivia.Classes;
using SinticBolivia.Database;
using SinticBolivia.Modules.MoneyTransfer.Entities;

namespace SinticBolivia.Modules.MoneyTransfer.Controllers
{
    public class PaymentMethodsController : BaseController
    {
        construct
        {

        }
        public override void register_routes()
        {
            this.add_route("GET", """/api/moneytransfer/paymentmethods/?$""", this.read_all).set_protected(true);
            this.add_route("POST", """/api/moneytransfer/paymentmethods/?$""", this.create).set_protected(true);
        }
        public RestResponse? create(SBCallbackArgs args)
        {
            try
            {
                var pm = this.toObject<PaymentMethod>();
                if( pm == null )
                    throw new SBException.GENERAL("Datos invalido, no se puede el metodo de pago");
                pm.save();
                return new RestResponse(Soup.Status.CREATED, pm.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read_all(SBCallbackArgs args)
        {
            try
            {
                int page = this.get_int("page", 1);
                int limit = this.get_int("limit", 25);
                int offset  = (page > 1) ? ((page - 1) * limit) : 0;
                var items   = Entity.limit(limit, offset)
                    .order_by("creation_date", "DESC")
                    .get<PaymentMethod>();
                return new RestResponse(Soup.Status.CREATED, items.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
    }
}
