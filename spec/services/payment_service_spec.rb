require "rails_helper"

describe CreateClientService do
    let(:client) { FactoryBot.create(:client_user) }
    let(:stripe_obj) { Struct.new(:stripe_token, :last_four, :card_brand)
                             .new("tok_visa", "0123", "Visa") }
  describe "#charge!" do
    it "successfully charges client" do
      subject = PaymentService.new(client, "academic", 2.0).charge!(stripe_obj)

      expect(subject.success?).to be true
    end

    it "fails with bad hours" do
      stripe_obj.stripe_token = "bad_token"
      subject = PaymentService.new(client, "academic", 1.11).charge!(stripe_obj)

      expect(subject.success?).to be false
    end

    it "successfully adjusts client academic credit" do
      subject = client.test_prep_credit
      hours = 2.0
      PaymentService.new(client, "academic", hours).charge!(stripe_obj)

      expect(subject).to eq(client.reload.academic_credit - hours)
    end

    it "successfully adjusts client test prep credit" do
      subject = client.test_prep_credit
      hours = 1.25
      PaymentService.new(client, "test_prep", hours).charge!(stripe_obj)

      expect(subject).to eq(client.reload.test_prep_credit - hours)
    end
  end
end
