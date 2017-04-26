class Transfer
  attr_reader :error

  def initialize(payment)
    @payment = payment
  end

  def perform
    create_transfer
    if !@gateway.error
      tutor.invoices.each do |invoice|
        invoice.paid!
      end
      tutor.out_standing_balance = 0.0
      tutor.save
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
end
