using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Dto
{
    public class DtoVeriffResponse : SBSerializable
    {
        public  string status {get;set;}
        public  string id {get;set;}
        public  string url {get;set;}
        public  string? vendorData {get;set;}
        public  string host {get;set;}
        public  string sessionToken {get;set;}

        public DtoVeriffResponse()
        {

        }
    }
}
