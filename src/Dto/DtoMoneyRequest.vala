using SinticBolivia.Modules.MoneyTransfer.Entities;

namespace SinticBolivia.Modules.MoneyTransfer.Dto
{
    public class DtoMoneyRequest
    {
        public  long        id {get;set;}
        public  long        source_id {get;set;}
        public  long        target_id {get;set;}
        public  long        payment_method_id {get;set;}
        public  string          notes {get;set;}
        public  SBDateTime?     request_date {get;set;}
        public  SBDateTime?     limit_date {get;set;}
        public  string          status {get;set;}
        public  string          attachment;

        public DtoMoneyRequest()
        {

        }
        public MoneyRequest to_request()
        {
            var req = new MoneyRequest();
            req.id = this.id;
            req.source_id = this.source_id;
            req.target_id = this.target_id;
            req.payment_method_id = this.payment_method_id;
            req.notes = this.notes;
            req.request_date = this.request_date;
            req.limit_date = this.limit_date;
            req.status = this.status;

            return req;
        }
    }
}
