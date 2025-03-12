using SinticBolivia;
using SinticBolivia.Classes;
using SinticBolivia.Modules.MoneyTransfer.Models;
using SinticBolivia.Modules.MoneyTransfer.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Controllers
{
    public abstract class BaseController : RestController
    {
        protected   UserProfile         profile;

        public override RestResponse? before_dispatch(SBWebRoute webroute, RestHandler handler, out bool next)
        {
            try
            {
                if( !webroute.is_protected )
                {
                    next = true;
                    return null;
                }
                string jwt = this.get_jwt();
                debug("ROUTE: %s\nMONEYTRANSFER JWT: %s\n", webroute.route, jwt);
                var modelAuth = new AuthenticationModel();
                modelAuth.verify_token(jwt, out this.profile);
                if( this.profile == null || this.profile.user_id <= 0 )
                    throw new SBException.GENERAL("Invalid user profile, unable to complete operation");
                next = true;
                debug(profile.dump());
                return null;
            }
            catch(SBException e)
            {
                next = false;
                return new RestResponse(Soup.Status.UNAUTHORIZED, e.message);
            }
        }
    }
}
