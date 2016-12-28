  class TransferWorker
    include Sidekiq::Worker
    sidekiq_options retry: 2

    def perform(payment_id)
      payment = Payment.find(payment_id)

      Transfer.new(PaymentGatewayDwolla).create_transfer(payment)
    end
  end
