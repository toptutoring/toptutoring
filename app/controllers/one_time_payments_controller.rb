class OneTimePaymentsController < ApplicationController
  def create
    results = PaymentService.new(source, payment_params).charge!
    if results.success?
      flash.now[:notice] = results.message
      @payment = results.payment
      render "confirmation"
    else
      flash.alert = results.message
      redirect_to action: :new
    end
  end

  private

  def payment_params
    params.require(:payment)
          .permit(:description, :amount, :payer_email)
          .merge(one_time: true)
  end

  def source
    params.require(:stripe_token)
  end
end
