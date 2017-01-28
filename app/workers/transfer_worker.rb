  class TransferWorker
    include Sidekiq::Worker
    sidekiq_options retry: 2

    def perform(payment_id)
      @payment = Payment.find(payment_id)

      if Transfer.new(PaymentGatewayDwolla).create_transfer(@payment)
        UpdateUserBalance.new(@payment.amount, tutor_id).decrease
      end
    end

    private

    def tutor_id
      User.find(@payment.payee_id).id
    end
  end
