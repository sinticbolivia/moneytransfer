using SinticBolivia.Classes;
using SinticBolivia.Database;
using SinticBolivia.Modules.MoneyTransfer.Dto;
using SinticBolivia.Modules.MoneyTransfer.Services;

namespace SinticBolivia.Modules.MoneyTransfer.Controllers
{
    public class VeriffController : BaseController
    {
        public override void register_routes()
        {
            this.add_route(
                "POST",
                """/api/moneytransfer/veriff/upload-document/?$""",
                this.upload_document
            ).set_protected(true);
        }
        public RestResponse? upload_document(SBCallbackArgs args)
        {
            //var model = new AuthenticationModel();
            try
            {
                //long id = args.get_long("id");
                //if( id <= 0 )
                //    throw new SBException.GENERAL("Invalid user identifier");

                var data = this.toObject<DtoVeriffRequest>();
                if( data.front_image.length <= 0 )
                    throw new SBException.GENERAL("Invalid user front image");
                if( data.back_image.length <= 0 )
                    throw new SBException.GENERAL("Invalid user back image");
                if( data.front_mime.length <= 0 )
                    throw new SBException.GENERAL("Invalid user front image mime type");
                if( data.back_mime.length <= 0 )
                    throw new SBException.GENERAL("Invalid user back image mime type");

                var dtoveriff = new DtoVeriffSession();
                dtoveriff.callback = SBFactory.config.get_string("veriff_callback");
                dtoveriff.firstName = this.profile.first_name;
                dtoveriff.lastName = this.profile.last_name;
                dtoveriff.idNumber = data.document_number;
                dtoveriff.number = data.document_number;
                dtoveriff.doc_type = "ID_CARD";
                dtoveriff.country = "BO";
                dtoveriff.fullAddress = "Lorem Ipsum 30, 13612 Tallinn, Estonia";
                dtoveriff.vendorData = "UID-%ld".printf(this.profile.user_id);
                dtoveriff.ctype = "ine";
                dtoveriff.approved = true;
                debug(dtoveriff.to_json());
                var service = new ServiceVeriff(
                    SBFactory.config.get_string("veriff_api_key"),
                    SBFactory.config.get_string("veriff_shared_key")
                );
                debug("CREATING VERIFF SESSION");
                var vres = service.create_session(dtoveriff);

                debug("UPLOADING VERIFF SESSION MEDIA");
                service.send_session_media(vres.id, data.get_front_media());
                service.send_session_media(vres.id, data.get_back_media());
                //debug(vres.dump());
                return new RestResponse(Soup.Status.OK, vres.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
    }
}
