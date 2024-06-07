using GLib;
using SinticBolivia.Classes;
using SinticBolivia.Database;
using SinticBolivia.Modules.MoneyTransfer.Entities;
using SinticBolivia.Modules.MoneyTransfer.Models;
using SinticBolivia.Modules.MoneyTransfer.Dto;
using SinticBolivia.Modules.MoneyTransfer.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Controllers
{
    public class MoneyRequestController : BaseController
    {
        protected   MoneyRequestsModel  model;

        construct
        {
            this.model = new MoneyRequestsModel();
        }
        public override void register_routes()
        {
            this.add_route("POST", "/api/moneytransfer/requests/?$", this.create).set_protected(true);
            this.add_route("GET", "/api/moneytransfer/requests/?$", this.read_all)
                .set_protected(true)
                .set_name("requests.read_all")
            ;
            this.add_route("GET", "/api/moneytransfer/requests-external/?$", this.read_all_external)
                .set_protected(true)
                .set_name("requests.read_all_external")
            ;
            this.add_route("GET", """/api/moneytransfer/requests/(?P<id>\d+)/?$""", this.read)
                .set_protected(true)
            ;
            this.add_route("GET", """/api/moneytransfer/requests/(?P<id>\d+)/states/?$""", this.read_states)
                .set_protected(true)
            ;
            this.add_route("GET", """/api/moneytransfer/requests/(?P<id>\d+)/accept/?$""", this.accept)
                .set_protected(true)
            ;
            this.add_route("GET", """/api/moneytransfer/requests/(?P<id>\d+)/reject/?$""", this.reject)
                .set_protected(true)
            ;
            this.add_route("GET", """/api/moneytransfer/requests/(?P<id>\d+)/completed/?$""", this.completed)
                .set_protected(true)
            ;
            this.add_route("POST", """/api/moneytransfer/requests/(?P<id>\d+)/attachments/?$""", this.upload_attachment)
                .set_protected(true)
            ;
            this.add_route("GET", """/api/moneytransfer/requests/(?P<id>\d+)/attachments/(?P<aid>\d+)/?$""", this.read_attachment)
                .set_protected(true)
            ;
            this.add_route("GET", """/api/moneytransfer/requests/users/(?P<id>\d+)/?$""", this.read_user_requests)
                .set_protected(true)
            ;
            this.add_route("GET", """/api/moneytransfer/enquiries/users/(?P<id>\d+)/?$""", this.read_user_enquiries).set_protected(true);
        }

        public RestResponse create(SBCallbackArgs args)
        {
            try
            {
                var request = this.toObject<MoneyRequest>();
                this.model.profile = this.profile;
                this.model.create(request);
                return new RestResponse(Soup.Status.CREATED, request.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse read_all(SBCallbackArgs args)
        {
            try
            {
                int page    = this.get_int("page", 1);
                int limit   = this.get_int("limit", 25);
                int offset  = (page > 1) ? ((page - 1) * limit) : 0;
                var items   = Entity.limit(limit, offset)
                    .order_by("creation_date", "DESC")
                    .get<MoneyRequest>();

                return new RestResponse(Soup.Status.OK, items.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse read_all_external(SBCallbackArgs args)
        {
            try
            {
                if( this.profile.user_id <= 0 )
                    throw new SBException.GENERAL("Identificador de usuario invalido");
                var items = Entity.where("target_id", "=", this.profile.user_id).get<MoneyRequest>();
                return new RestResponse(Soup.Status.OK, items.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse read(SBCallbackArgs args)
        {
            try
            {
                long id     = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("El identificador de solicitud es invalido");
                var request = Entity.read<MoneyRequest>(id);
                if( request == null )
                    throw new SBException.GENERAL("La solicitud no existe");

                return new RestResponse(Soup.Status.OK, request.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse read_states(SBCallbackArgs args)
        {
            try
            {
                long id     = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("El identificador de solicitud es invalido");
                var request = Entity.read<MoneyRequest>(id);
                if( request == null )
                    throw new SBException.GENERAL("La solicitud no existe");
                var items = request.get_states();
                return new RestResponse(Soup.Status.OK, items.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? upload_attachment(SBCallbackArgs args)
        {
            long req_id = args.get_long("id");
            try
            {
                if( req_id <= 0 )
                    throw new SBException.GENERAL("Identificador de solicitud invalido");
                var req = Entity.where("id", "=", req_id).first<MoneyRequest>();
                if( req == null )
                    throw new SBException.GENERAL("La solicitud no existe, no se puede subir el adjunto");
                DtoAttachmentData adata = this.toObject<DtoAttachmentData>();
                if( adata == null )
                    throw new SBException.GENERAL("Datos de adjunto invalidos");
                if( adata.filename.length <= 0 )
                    throw new SBException.GENERAL("Nombre de adjunto invalido");
                if( adata.buffer.length <= 0 )
                    throw new SBException.GENERAL("Buffer de adjunto invalido");

                string path = "./storage/attachments";
                if( !FileUtils.test(path, FileTest.IS_DIR) )
                {
                    var file = File.new_for_commandline_arg(path);
                    file.make_directory_with_parents();
                }
                string filename = Uuid.string_random() + ".jpg";
                FileUtils.set_data(path + "/" + filename, adata.get_binary_buffer());
                var attachment = new Attachment();
                attachment.request_id = req_id;
                attachment.name = filename;
                attachment.description = "";
                attachment.filename = filename;
                attachment.atype = "qr_image"; //adata.mime;
                attachment.save();

                return new RestResponse(Soup.Status.CREATED, attachment.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
            catch(GLib.FileError e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
            catch(GLib.Error e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read_attachment(SBCallbackArgs args)
        {
            try
            {
                long id     = args.get_long("id");
                long aid    = args.get_long("aid");
                int buffer  = this.get_int("buffer", 0);
                if( id <= 0 )
                    throw new SBException.GENERAL("Identificador de solicitud invalido");
                if( aid <= 0 )
                    throw new SBException.GENERAL("Identificador de adjunto invalido");
                var attachment = Entity.where("id", "=", aid).and().equals("request_id", id).first<Attachment>();
                if( attachment == null )
                    throw new SBException.GENERAL("El adjunto no existe");
                if( buffer <= 0 )
                    return new RestResponse(Soup.Status.OK, attachment.to_json(), "application/json");

                //return new RestResponse(Soup.Status.OK, Base64.encode(attachment.get_buffer()), "text/plain");
                return new RestResponse(Soup.Status.OK,
                    """{"id": %ld,"buffer": "%s"}""".printf(attachment.id, Base64.encode(attachment.get_buffer())),
                    "application/json"
                );
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? accept(SBCallbackArgs args)
        {
            try
            {
                if( !this.profile.can("mt.accept_request") )
                    throw new SBException.GENERAL("No tiene permisos para poder aceptar la solicitud");
                var request = Entity.read<MoneyRequest>(args.get_long("id"));
                if( request == null )
                    throw new SBException.GENERAL("Solicitud no existente");

                this.model.profile = this.profile;
                this.model.accept(request, this.profile);
                return new RestResponse(Soup.Status.OK, request.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? reject(SBCallbackArgs args)
        {
            try
            {
                if( !this.profile.can("mt.reject_request") )
                    throw new SBException.GENERAL("No tiene permisos para poder rechazar la solicitud");
                var request = Entity.read<MoneyRequest>(args.get_long("id"));
                if( request == null )
                    throw new SBException.GENERAL("Solicitud no existente");
                this.model.profile = this.profile;
                this.model.reject(request, this.profile);
                return new RestResponse(Soup.Status.OK, request.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? completed(SBCallbackArgs args)
        {
            try
            {
                if( !this.profile.can("mt.complete_request") )
                    throw new SBException.GENERAL("No tiene permisos para poder completar la solicitud");
                var request = Entity.read<MoneyRequest>(args.get_long("id"));
                if( request == null )
                    throw new SBException.GENERAL("Solicitud no existente");
                this.model.profile = this.profile;
                this.model.complete(request, this.profile);
                return new RestResponse(Soup.Status.OK, request.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read_user_requests(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id", 0);
                if( id <= 0 )
                    throw new SBException.GENERAL("Identificador de usuario invalido");
                var items = Entity.where("source_id", "=", id).order_by("request_date", "desc").get<MoneyRequest>();
                return new RestResponse(Soup.Status.OK, items.to_json(), "application/json; charset=utf-8");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read_user_enquiries(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id", 0);
                if( id <= 0 )
                    throw new SBException.GENERAL("Identificador de usuario invalido");
                var items = Entity.where("target_id", "=", id).get<MoneyRequest>();
                return new RestResponse(Soup.Status.OK, items.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
    }
}
