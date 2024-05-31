using GLib;

namespace SinticBolivia.Modules.MoneyTransfer.Dto
{
    public class DtoAttachmentData
    {
        public  string  filename {get;set;}
        public  string  buffer {get;set;}
        public  string  mime {get;set;}

        public DtoAttachmentData()
        {

        }
        public uint8[] get_binary_buffer()
        {
            return (uint8[])Base64.decode(this.buffer);
        }
    }
}
