using SinticBolivia.Database;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Entities
{
    public class MoneyRequest : Entity
    {
        public const string     STATUS_PENDING      = "PENDING";
        public const string     STATUS_ACCEPTED     = "ACCEPTED";
        public const string     STATUS_REJECTED     = "REJECTED";
        public const string     STATUS_PROCESSING   = "PROCESSING";
        public const string     STATUS_COMPLETED    = "COMPLETED";
        public const string     STATUS_VOID         = "VOID";
        public const string     STATUS_REQUEST_AUTHORIZED    = "REQUEST_AUTHORIZED";
        public const string     STATUS_REQUEST_DENIED        = "REQUEST_DENIED";

        public  long        id {get;set;}
        public  long        source_id {get;set;}
        public  long        target_id {get;set;}
        public  string      source_name {get;set;}
        public  string      target_name {get;set;}
        public  long        payment_method_id {get;set;}
        public  string      notes {get;set;}
        public  SBDateTime?  request_date {get;set;}
        public  SBDateTime?  limit_date {get;set;}
        public  string      status {get;set;}
        public  string      completed {get;set; default = "0";}
        public  string      deleted {get;set; default = "0";}
        public  double      amount {get;set;default = 0;}

        construct
        {
            this._table = "mr_requests";
            this._primary_key = "id";
        }
        public MoneyRequest()
        {

        }
        public SBHasOne<PaymentMethod> payment_method()
        {
            return this.has_one<PaymentMethod>("id", "payment_method_id");
        }
        public PaymentMethod get_payment_method()
        {
            return this.payment_method().get();
        }
        public SBHasMany<RequestState> states()
        {
            return this.has_many<RequestState>("request_id", "id");
        }
        public SBCollection<RequestState> get_states()
        {
            return this.states().get();
        }
        public Attachment? get_qr_image()
        {
            return this.has_many<Attachment>("request_id", "id").builder.equals("atype", "qr_image").first();
        }
        public override Json.Object to_json_object()
        {
            var qr_image = this.get_qr_image();
            var obj = base.to_json_object();
            obj.set_object_member("payment_method", this.get_payment_method().to_json_object());
            if( qr_image != null )
                obj.set_object_member("qr_image", qr_image.to_json_object());
            return obj;
        }
        public RequestState build_state(string notes, string old_status, string new_status, long user_id)
        {
            var state = new RequestState();
            state.request_id = this.id;
            state.user_id = user_id;
            state.old_status = old_status;
            state.new_status = new_status;
            state.notes = notes;
            return state;
        }
    }
}
