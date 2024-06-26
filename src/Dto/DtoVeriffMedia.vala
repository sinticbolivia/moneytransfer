using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Dto
{
    public class DtoVeriffMedia : SBSerializable
    {
        public  string  context {get;set;}
        public  string  content {get;set;}

        public DtoVeriffMedia()
        {
            base();
        }
        public void set_image(string filename)
        {

        }
        public override Json.Object to_json_object()
        {
            var obj = new Json.Object();
            var image = new Json.Object();
            image.set_string_member("context", this.context);
            image.set_string_member("content", this.content);

            obj.set_object_member("image", image);

            return obj;
        }
    }
}
