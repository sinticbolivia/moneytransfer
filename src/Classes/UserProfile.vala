using Gee;
using SinticBolivia;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.MoneyTransfer.Classes
{
    public class UserProfile : SBSerializable
    {
        public  long user_id {get;set;}
        public  string first_name {get;set;}
        public  string last_name {get;set;}
        public  string username {get;set;}
        public  string email {get;set;}
        public  string status {get;set;}
        public  long    role_id {get;set;}
        public  long    store_id {get;set;}
        public  string?  role_key {get;set;}
        public  ArrayList<string>?   permissions {get;set;}
        public  string  avatar {get;set;}
        public  string? last_modification_date {get;set;}
        public  string? creation_date {get;set;}
        public  string  jwt;
        public  string  fullname {owned get{return "%s %s".printf(this.first_name, this.last_name).strip();}}

        public UserProfile()
        {

        }
        public bool is_root()
        {
            return (this.role_id === 0 && this.username == "root");
        }
        public bool can(string permission)
        {
            if( this.is_root() )
                return true;
                
            return true;
        }
    }
}
