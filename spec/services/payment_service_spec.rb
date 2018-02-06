require "rails_helper"

describe CreateClientService do
  let(:client) { FactoryBot.create(:client_user) }
  let(:payment_params) { { hours_type: "online_academic", hours_purchased: "2.0", payer_id: client.id } }
  let(:token) { "tok_visa" }
  let(:stripe_account) { FactoryBot.create(:stripe_account) }

  describe "#charge!" do
    it "successfully charges client" do
      subject = PaymentService.new(token, payment_params, nil).charge!

      expect(subject.success?).to be true
    end

    it "fails with bad hours" do
      payment_params[:hours_purchased] = "1.11"
      subject = PaymentService.new(token, payment_params, nil).charge!

      expect(subject.success?).to be false
    end

    it "successfully adjusts client academic credit" do
      subject = client.online_test_prep_credit
      PaymentService.new(token, payment_params, nil).charge!

      hours = payment_params[:hours_purchased].to_f
      expect(subject).to eq(client.reload.online_academic_credit - hours)
    end

    it "successfully adjusts client test prep credit" do
      subject = client.online_test_prep_credit
      payment_params[:hours_purchased] = "1.25"
      payment_params[:hours_type] = "online_test_prep"
      PaymentService.new(token, payment_params, nil).charge!

      hours = payment_params[:hours_purchased].to_f
      expect(subject).to eq(client.reload.online_test_prep_credit - hours)
    end

    it "successfully adjusts client in-person test prep credit" do
      subject = client.in_person_test_prep_credit
      payment_params[:hours_purchased] = "1.25"
      payment_params[:hours_type] = "in_person_test_prep"
      PaymentService.new(token, payment_params, nil).charge!

      hours = payment_params[:hours_purchased].to_f
      expect(subject).to eq(client.reload.in_person_test_prep_credit - hours)
    end

    it "successfully charges a stored card" do
      subject = PaymentService.new(stripe_account.default_source_id, payment_params, stripe_account).charge!

      expect(subject.success?).to be true
    end
  end
end
