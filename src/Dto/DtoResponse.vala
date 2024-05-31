using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Dto
{
    public class DtoResponse<T> : SBObject
    {
        public  string  response {get;set;}
        public  int     code {get;set;}
        public  T       data {get;set;}

        public DtoResponse()
        {

        }
    }
}
