require "rails_helper"

describe CreateClientService do
  let(:client) { FactoryBot.create(:client_user) }
  let(:payment_params) { { hours_type: "online_academic", hours_purchased: "2.0",
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
      subject = client.online_test_prep_credit
      PaymentService.new(payment_params, token).charge!

      hours = payment_params[:hours_purchased].to_f
      expect(subject).to eq(client.reload.online_academic_credit - hours)
    end

    it "successfully adjusts client test prep credit" do
      subject = client.online_test_prep_credit
      payment_params[:hours_purchased] = "1.25"
      payment_params[:hours_type] = "online_test_prep"
      PaymentService.new(payment_params, token).charge!

      hours = payment_params[:hours_purchased].to_f
      expect(subject).to eq(client.reload.online_test_prep_credit - hours)
    end

    it "successfully adjusts client in-person test prep credit" do
      subject = client.in_person_test_prep_credit
      payment_params[:hours_purchased] = "1.25"
      payment_params[:hours_type] = "in_person_test_prep"
      PaymentService.new(payment_params, token).charge!

      hours = payment_params[:hours_purchased].to_f
      expect(subject).to eq(client.reload.in_person_test_prep_credit - hours)
    end
  end
end
