using GLib;
using SinticBolivia.Classes;
using SinticBolivia.Modules.MoneyTransfer.Classes;
using SinticBolivia.Modules.MoneyTransfer.Dto;

namespace SinticBolivia.Modules.MoneyTransfer.Models
{
    public class AuthenticationModel
    {
        protected   string  service_users_endpoint;
        protected   string  service_profile_endpoint;

        public AuthenticationModel()
        {
            var config = SBFactory.config;
            this.service_profile_endpoint = (string)config.GetValue("service_profile");
            this.service_users_endpoint = (string)config.GetValue("service_users");
        }
        protected UserProfile get_profile_from_response(Json.Object? obj)
        {
            var profile = new UserProfile();
            if( obj == null )
            {
                debug("Object response is null, unable to get user profile");
                return profile;
            }
            var objData = obj.get_object_member("data");
            if( objData == null )
            {
                debug("Object response, data member is null, unable to get user profile");
                return profile;
            }
            profile.bind_json_object(objData);
            return profile;
        }
        public bool verify_token(string jwt, out UserProfile profile) throws SBException
        {
            if( this.service_profile_endpoint.strip().length <= 0 )
                throw new SBException.GENERAL("MICROSERVICE PROFILE ENDPOINT IS INVALID");
            debug("MICROSERVICE PROFILE ENDPOINT: %s\n", this.service_profile_endpoint);

            var request = new SBRequest();
            request.headers.set("Authorization", "Bearer %s".printf(jwt));
            var response = request.get(this.service_profile_endpoint);
            debug("MICROSERVICE PROFILE RESPONSE(%d): %s\n", response.code, response.body);
            if( !response.ok )
            {
                debug(response.body);
                throw new SBException.GENERAL("Autenticacion invalida");
            }
            profile = this.get_profile_from_response(response.to_json_object());
            profile.jwt = jwt;
            return true;
        }
        public UserProfile get_user_by_id(long id, string jwt) throws SBException
        {
            if( this.service_users_endpoint.strip().length <= 0 )
                throw new SBException.GENERAL("MICROSERVICE PROFILE ENDPOINT IS INVALID");
            var request = new SBRequest();
            request.headers.set("Authorization", "Bearer %s".printf(jwt));
            var response = request.get(this.service_users_endpoint + "/%ld".printf(id));
            if( !response.ok )
                throw new SBException.GENERAL("Autenticacion invalida");
            return this.get_profile_from_response(response.to_json_object());
        }

    }
}
