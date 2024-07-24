using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Dto
{
    public class DtoVeriffSession : SBSerializable
    {
        public  string callback {get;set;}
        public  string? vendorData {get;set;}
        //person fields
        public  string firstName {get;set;}
        public  string lastName {get;set;}
        public  string idNumber {get;set;}
        //document fields
        public  string number {get;set;}
        public  string doc_type {get;set;}
        public  string country {get;set;}
        //address fields
        public  string fullAddress {get;set;}

        //consents fields
        public  string ctype {get;set;}
        public  bool approved {get;set;}

        public DtoVeriffSession()
        {

        }
        public override Json.Object to_json_object()
        {
            var obj = new Json.Object();
            var person = new Json.Object();
            person.set_string_member("firstName", this.firstName);
            person.set_string_member("lastName", this.lastName);
            person.set_string_member("idNumber", this.idNumber);
            var document = new Json.Object();
            document.set_string_member("number", this.number);
            document.set_string_member("type", this.doc_type);
            document.set_string_member("country", this.country);
            var address = new Json.Object();
            address.set_string_member("fullAddress", this.fullAddress);

            var consent_1 = new Json.Object();
            consent_1.set_string_member("type", this.ctype);
            consent_1.set_boolean_member("approved", this.approved);
            var consents = new Json.Array();
            consents.add_object_element(consent_1);

            obj.set_object_member("person", person);
            obj.set_object_member("document", document);
            obj.set_object_member("address", address);
            obj.set_array_member("consents", consents);
            obj.set_string_member("callback", this.callback);
            if( this.vendorData != null )
                obj.set_string_member("vendorData", this.vendorData);
            var root = new Json.Object();
            root.set_object_member("verification", obj);
            return root;
        }
    }
}
