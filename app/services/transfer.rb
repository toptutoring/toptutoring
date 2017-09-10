class Transfer
  def initialize(payment)
    @payment = payment
  end

  def perform
    create_transfer
    if @gateway.error
      false
    else
      tutor.outstanding_balance = 0.0
      tutor.save
    end
  end

  private

  def create_transfer
    @gateway = PaymentGatewayDwolla.new(@payment)
    @gateway.create_transfer
  end

  def tutor
    @tutor ||= User.find(@payment.payee_id)
  end
end
