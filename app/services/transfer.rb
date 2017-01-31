class Transfer
  attr_reader :error

  def initialize(payment)
    @payment = payment
  end

  def perform
    create_transfer
    if !@gateway.error
      UpdateUserBalance.new(@payment.amount, tutor_id).decrease
    else
      @error = @gateway.error
    end
  end

  private

  def set_dwolla_gateway
    @gateway = PaymentGatewayDwolla.new(@payment)
  end

  def create_transfer
    set_dwolla_gateway
    @gateway.create_transfer
  end

  def tutor_id
    User.find(@payment.payee_id).id
  end
end
