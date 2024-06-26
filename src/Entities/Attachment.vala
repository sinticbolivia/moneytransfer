using SinticBolivia.Database;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Entities
{
    public class Attachment : Entity
    {
        public  long    id {get;set;}
        public  long    request_id {get;set;}
        public  string  name {get;set;}
        public  string  description {get;set;}
        public  string  filename {get;set;}
        public  string  atype {get;set;}

        construct
        {
            this._table = "mr_request_attachments";
            this._primary_key = "id";
        }
        public Attachment()
        {

        }
        public uint8[] get_buffer()
        {
            uint8[] contents;
            FileUtils.get_data("./storage/attachments/%s".printf(this.filename), out contents);
            return contents;
        }
    }
}
