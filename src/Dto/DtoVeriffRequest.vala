using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Dto
{
    public class DtoVeriffRequest : SBSerializable
    {
        public  string  front_image {get;set;}
        public  string  back_image {get;set;}
        public  string  document_number {get;set;}
        public  string  front_mime {get;set;}
        public  string  back_mime {get;set;}

        public DtoVeriffRequest()
        {

        }
        public uint8[] get_binary_buffer(string side = "front")
        {
            if( side == "back" )
                return (uint8[])Base64.decode(this.back_image);
            return (uint8[])Base64.decode(this.front_image);
        }
        public DtoVeriffMedia get_media(string type)
        {
            var media = new DtoVeriffMedia();
            if( type == "back" )
            {
                media.context = "document-back";
                media.content = "data:%s;base64,%s".printf(this.back_mime, this.back_image);
            }
            else
            {
                media.context = "document-front";
                media.content = "data:%s;base64,%s".printf(this.front_mime, this.front_image);
            }

            return media;
        }
        public DtoVeriffMedia get_front_media()
        {
            return this.get_media("front");
        }
        public DtoVeriffMedia get_back_media()
        {
            return this.get_media("back");
        }
    }
}
