using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Services
{
    public class ServiceFirebase
    {
        protected   string  service_endpoint;
        public      string  jwt;

        public ServiceFirebase(string _jwt)
        {
            this.jwt = _jwt;
            var config = SBFactory.config;
            this.service_endpoint = (string)config.GetValue("service_firebase");
        }
        public void sendMessage(long userId, string title, string message) throws SBException
        {
            string json = """{"user_id": %ld, "title": "%s", "message": "%s"}""".printf(
                userId,
                title,
                message
            );
            debug("FIREBASE JSON: %s\n", json);
            var request = new SBRequest();
            request.headers.set("Content-Type", "application/json");
            request.headers.set("Authorization", "Bearer %s".printf(this.jwt));
            var response = request.post(this.service_endpoint, json);
            debug("MICROSERVICE FIREBASE RESPONSE: %s\n", response.body);
            if( !response.ok )
            {
                debug(response.body);
                throw new SBException.GENERAL("Autenticacion invalida");
            }
        }
    }
}
