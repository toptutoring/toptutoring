require "rails_helper"

describe CreateClientService do
  let(:client) { FactoryBot.create(:client_user) }
  let(:purchase_params) { { academic_type: "academic", hours_desired: "2.0", stripe_token: "tok_visa",
                            card_brand: "Visa", last_four: "4242", card_holder_name: "Client" } }

  describe "#charge!" do
    it "successfully charges client" do
      subject = PaymentService.new(client, purchase_params).charge!

      expect(subject.success?).to be true
    end

    it "fails with bad hours" do
      purchase_params[:hours_desired] = "1.11"
      subject = PaymentService.new(client, purchase_params).charge!

      expect(subject.success?).to be false
    end

    it "successfully adjusts client academic credit" do
      subject = client.test_prep_credit
      PaymentService.new(client, purchase_params).charge!

      hours = purchase_params[:hours_desired].to_f
      expect(subject).to eq(client.reload.academic_credit - hours)
    end

    it "successfully adjusts client test prep credit" do
      subject = client.test_prep_credit
      purchase_params[:hours_desired] = "1.25"
      purchase_params[:academic_type] = "test_prep"
      PaymentService.new(client, purchase_params).charge!

      hours = purchase_params[:hours_desired].to_f
      expect(subject).to eq(client.reload.test_prep_credit - hours)
    end
  end
end
