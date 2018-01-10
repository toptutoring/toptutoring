require "rails_helper"

describe CreateClientService do
  let(:client) { FactoryBot.create(:client_user) }
  let(:payment_params) { { hours_type: "academic", hours_purchased: "2.0",
                            card_brand: "Visa", last_four: "4242", rate: 20_00,
                            card_holder_name: "Client", payer_id: client.id } }
  let(:token) { { stripe_token: "tok_visa" } }

  describe "#charge!" do
    it "successfully charges client" do
      subject = PaymentService.new(payment_params, token).charge!

      expect(subject.success?).to be true
    end

    it "fails with bad hours" do
      payment_params[:hours_purchased] = "1.11"
      subject = PaymentService.new(payment_params, token).charge!

      expect(subject.success?).to be false
    end

    it "successfully adjusts client academic credit" do
      subject = client.test_prep_credit
      PaymentService.new(payment_params, token).charge!

      hours = payment_params[:hours_purchased].to_f
      expect(subject).to eq(client.reload.academic_credit - hours)
    end

    it "successfully adjusts client test prep credit" do
      subject = client.test_prep_credit
      payment_params[:hours_purchased] = "1.25"
      payment_params[:hours_type] = "test_prep"
      PaymentService.new(payment_params, token).charge!

      hours = payment_params[:hours_purchased].to_f
      expect(subject).to eq(client.reload.test_prep_credit - hours)
    end
  end
end
