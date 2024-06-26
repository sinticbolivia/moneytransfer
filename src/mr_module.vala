using SinticBolivia.Classes;
using SinticBolivia.Modules.MoneyTransfer.Controllers;

namespace SinticBolivia.Modules.MoneyTransfer
{
    public class MTModule : Object, ISBRestModule
    {
        public string id {get; set construct;}
        public string name {get; set construct;}
        public string description {get; set construct;}
        public string version {get; set construct;}
        public static SBConfig  config;

        construct
        {
            this.id = "mr";
            this.name = "Money Transfer Module";
            this.description = "";
            this.version = "1.0.0";
        }
        public void set_config(SBConfig cfg)
        {
            config = cfg;
        }
        public void load()
        {
            message("Module %s loaded\n".printf(this.name));
        }
        public void init(RestServer server)
        {
            this.set_handlers(server);
            message("Module %s initialized\n".printf(this.name));
        }
        protected void set_handlers(RestServer server)
        {
            server.add_handler_args("/api/moneytransfer/requests", typeof(MoneyRequestController));
            server.add_handler_args("/api/moneytransfer/paymentmethods", typeof(PaymentMethodsController));
            server.add_handler_args("/api/moneytransfer/parameters", typeof(ParametersController));
            server.add_handler_args("/api/moneytransfer/wallets", typeof(WalletsController));
            server.add_handler_args("/api/moneytransfer/withdrawals", typeof(WithdrawalsController));
            server.add_handler_args("/api/moneytransfer/veriff", typeof(VeriffController));
        }
    }
}
public Type sb_get_rest_module_type()
{
    return typeof(SinticBolivia.Modules.MoneyTransfer.MTModule);
}
