class Transfer
  attr_reader :error

  def initialize(payment)
    @payment = payment
  end

  def perform
    create_transfer
    if !@gateway.error
      UpdateUserBalance.new(hourly_amount, tutor_id).decrease
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

  def tutor
    @tutor ||= User.find(@payment.payee_id)
  end

  def tutor_id
    tutor.id
  end

  def tutor_hourly_rate
    tutor.tutor_info.hourly_rate
  end

  def hourly_amount
    @payment.amount.to_f / tutor_hourly_rate
  end
end
