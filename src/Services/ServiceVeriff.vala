using Gee;
using SinticBolivia.Classes;
using SinticBolivia.Modules.MoneyTransfer.Dto;

namespace SinticBolivia.Modules.MoneyTransfer.Services
{
    public class ServiceVeriff : SBRequest
    {
        protected   string base_url = "https://stationapi.veriff.com";
        protected   string api_key;
        protected   string shared_key;

        public ServiceVeriff(string apikey, string skey)
        {
            base();
            this.api_key = apikey;
            this.shared_key = skey;
        }
        protected string build_hmac(string json)
        {
            //debug("SIGNING DATA: %s\n", json);
            //string signature_str = GLib.Hmac.compute_for_string(GLib.ChecksumType.SHA256, this.shared_key.data, json);
            string signature = GLib.Hmac.compute_for_data(GLib.ChecksumType.SHA256, this.shared_key.data, json.data);
            debug("\nAPI KEY: %s\nSHARED KEY: %s\nSIGNATURE HMAC: %s",
                this.api_key,
                this.shared_key,
                signature
            );
            return signature;// + "\r\n";
        }
        protected void build_headers()
        {
            this.headers = null;
            this.headers = new HashMap<string, string>();
            this.headers.set("Content-Type", "application/json");
            this.headers.set("X-AUTH-CLIENT", this.api_key);
            //headers.set("X-HMAC-SIGNATURE", this.shared_key);
        }
        protected string build_endpoint(string endpoint)
        {
            return "%s/v1%s".printf(this.base_url, endpoint);
        }
        protected override SBResponse request(string url, string method = "GET", string? data = null)
        {
            string new_url = this.build_endpoint(url);
            this.build_headers();
            if( data != null && (url != "/sessions") )
                this.headers.set("X-HMAC-SIGNATURE", this.build_hmac(data));
            debug("VERIFF ENDPOINT (%s): %s\n", method, new_url);
            return base.request(new_url, method, data);
        }
        public DtoVeriffResponse? create_session(DtoVeriffSession session) throws SBException
        {
            string json = session.to_json();
            //debug("VERIFF SENDING SESSION JSON\n%s\n", json);
            var res = this.post("/sessions", json);
            debug("VERIFF SESSION RESPONSE");
            debug(res.body);
            if( !res.ok )
                throw new SBException.GENERAL("Invalid veriff request response");
            var obj = res.to_json_object();
            if( obj.get_string_member("status") != "success" )
                throw new SBException.GENERAL("Veriff session response error");
            var vres = new DtoVeriffResponse();
            vres.bind_json_object( obj.get_object_member("verification") );

            return vres;
        }
        public void send_session_media(string session_id, DtoVeriffMedia media)
        {
            string json = media.to_json();
            this.body_mime = "application/json";
            var res = this.post("/sessions/%s/media".printf(session_id), json);
            this.body_mime = "text/plain";
            debug(res.body);
        }
    }
}
