using GLib;
using SinticBolivia.Classes;
using SinticBolivia.Database;
using SinticBolivia.Modules.MoneyTransfer.Entities;

namespace SinticBolivia.Modules.MoneyTransfer.Controllers
{
    public class ParametersController : BaseController
    {
        public override void register_routes()
        {
            this.add_route("GET", """/api/moneytransfer/parameters/?$""", this.read);
            this.add_route("GET", """/api/moneytransfer/parameters/group/?$""", this.read_group);
            this.add_route("POST", """/api/moneytransfer/parameters/?$""", this.create).set_protected(true);
            this.add_route("PUT", """/api/moneytransfer/parameters/?$""", this.update).set_protected(true);
        }
        public RestResponse read(SBCallbackArgs args)
        {
            try
            {
                string key = this.get("key");
                var parameter = Entity.where("key", "=", key).first<SinticBolivia.Modules.MoneyTransfer.Entities.Parameter>();
                return new RestResponse(Soup.Status.CREATED, parameter.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse read_group(SBCallbackArgs args)
        {
            try
            {
                string keys = this.get("keys");
                if( keys.strip().length <= 0 )
                    throw new SBException.GENERAL("Nombre de parametros invalidos");
                string[] items = {};

                foreach(string key in keys.split(","))
                {
                    items += """"%s"""".printf(key);
                }
                var params = Entity.in("key", string.joinv(",", items)).get<SinticBolivia.Modules.MoneyTransfer.Entities.Parameter>();
                return new RestResponse(Soup.Status.CREATED, params.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse create(SBCallbackArgs args)
        {
            try
            {
                var parameter = this.toObject<SinticBolivia.Modules.MoneyTransfer.Entities.Parameter>();
                parameter.save();
                return new RestResponse(Soup.Status.CREATED, parameter.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse update(SBCallbackArgs args)
        {
            try
            {
                var parameter = this.toObject<SinticBolivia.Modules.MoneyTransfer.Entities.Parameter>();
                parameter.save();
                return new RestResponse(Soup.Status.CREATED, parameter.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
    }
}
