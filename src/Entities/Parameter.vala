using SinticBolivia.Database;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Entities
{
    public class Parameter : Entity
    {
        public  long    id {get;set;}
        public  string  key {get;set;}
        public  string  value {get;set;}

        construct
        {
            this._table = "mr_parameters";
            this._primary_key = "id";
        }
    }
}
