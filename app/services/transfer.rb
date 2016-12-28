class Transfer
  def initialize(payment_gateway)
    @payment_gateway = payment_gateway
  end

  def create_transfer(payment)
    @payment_gateway.new(payment).create_transfer
  end
end
