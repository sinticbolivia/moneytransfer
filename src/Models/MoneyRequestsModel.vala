using SinticBolivia.Database;
using SinticBolivia.Classes;
using SinticBolivia.Modules.MoneyTransfer.Entities;
using SinticBolivia.Modules.MoneyTransfer.Classes;
using SinticBolivia.Modules.MoneyTransfer.Services;

namespace SinticBolivia.Modules.MoneyTransfer.Models
{
    public class MoneyRequestsModel
    {
        public   UserProfile         profile;

        public MoneyRequestsModel()
        {

        }
        public void create(MoneyRequest request) throws SBException
        {
            if( request.source_id <= 0 )
                throw new SBException.GENERAL("La solicitud no tiene usuario origen");
            if( request.target_id <= 0 )
                throw new SBException.GENERAL("La solicitud no tiene usuario destino");
            if( request.payment_method_id <= 0 )
                throw new SBException.GENERAL("La solicitud no tiene un metodo de pago");

            var authModel = new AuthenticationModel();
            var target_user = authModel.get_user_by_id(request.target_id, this.profile.jwt);
            if( target_user == null )
                throw new SBException.GENERAL("Usuario destino no existente, no se puede realizar la solicitud");

            request.request_date = new SBDateTime();
            request.status = MoneyRequest.STATUS_PENDING;
            request.completed = "0";
            request.target_name = target_user.fullname;
            request.source_name = this.profile.fullname;
            request.save();
            request.build_state(
                "Nueva solicitud generada en estado pendiente",
                "INIT",
                MoneyRequest.STATUS_PENDING,
                request.source_id
            ).save();
            this.send_admin_notification(request);
        }
        public void send_admin_notification(MoneyRequest request)
        {
            //TODO: Send email to admin
        }
        public void accept(MoneyRequest request, UserProfile user)
        {
            request.build_state(
                "Solicitud aceptada",
                request.status,
                MoneyRequest.STATUS_ACCEPTED,
                user.user_id
            ).save();
            debug("Request state accepted");
            request.status = MoneyRequest.STATUS_ACCEPTED;
            request.save();
            debug("Request accepted");
            this.send_accepted_notification(request);
        }
        public void send_accepted_notification(MoneyRequest request)
        {
            //TODO: send email notification to source user
            var service = new ServiceFirebase(this.profile.jwt);
            service.sendMessage(request.source_id, "Solicitud Aceptada", "Su solicitud de pago fue aceptada");
            service.sendMessage(request.target_id, "Nueva Solicitud de Dinero", "Tiene una nueva solicitud de pago");
        }
        public void reject(MoneyRequest request, UserProfile user)
        {
            request.build_state(
                "Solicitud rechazada",
                request.status,
                MoneyRequest.STATUS_REJECTED,
                user.user_id
            ).save();
            request.status = MoneyRequest.STATUS_REJECTED;
            request.save();
            this.send_reject_notification(request);
        }
        public void send_reject_notification(MoneyRequest request)
        {
            //TODO: send email notification to source user
            var service = new ServiceFirebase(this.profile.jwt);
            service.sendMessage(request.source_id, "Solicitud Rechazada", "Su solicitud de pago fue rechazada");
        }
        public void complete(MoneyRequest request, UserProfile user)
        {
            request.build_state(
                "Solicitud completada.\n" +
                "El deposito fue realizo correctamente en la cuenta del solicitante.",
                request.status,
                MoneyRequest.STATUS_COMPLETED,
                user.user_id
            ).save();
            request.status = MoneyRequest.STATUS_COMPLETED;
            request.completed = "1";
            request.save();
            this.charge_wallet(request);
            this.send_completed_notification(request);
        }
        public void charge_wallet(MoneyRequest request)
        {
            double fee = 0;
            double amount_to_charge = request.amount - fee;
            var wallet = Entity.where("user_id", "=", request.source_id).first<Wallet>();
            if( wallet == null )
            {
                wallet = new Wallet();
                wallet.user_id = request.source_id;
            }
            wallet.amount += amount_to_charge;
            wallet.save();
            var charge = new WalletCharge();
            charge.wallet_id = wallet.id;
            charge.request_id = request.id;
            charge.amount = request.amount;
            charge.fee = fee;
            charge.charged_amount = amount_to_charge;
            charge.save();
        }
        public void send_completed_notification(MoneyRequest request)
        {
            //TODO: send email notification to source and target user
            var service = new ServiceFirebase(this.profile.jwt);
            service.sendMessage(request.source_id, "Solicitud Completada", "Su solicitud de pago y deposito fue completado");
            service.sendMessage(request.target_id, "Pago completado", "La solicitud de pago fue completada.");
        }
    }
}
