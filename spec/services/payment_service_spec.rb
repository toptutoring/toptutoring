require "rails_helper"

describe CreateClientService do
    let(:client) { FactoryBot.create(:client_user) }
  describe "#charge!" do
    it "successfully charges client" do
      subject = PaymentService.new(client, "academic", 2.0).charge!("tok_visa")

      expect(subject.success?).to be true
    end

    it "fails with bad hours" do
      subject = PaymentService.new(client, "academic", 1.11).charge!("waefwaefaw")

      expect(subject.success?).to be false
    end

    it "successfully adjusts client academic credit" do
      subject = client.test_prep_credit
      hours = 2.0
      PaymentService.new(client, "academic", hours).charge!("tok_visa")

      expect(subject).to eq(client.reload.academic_credit - hours)
    end

    it "successfully adjusts client test prep credit" do
      subject = client.test_prep_credit
      hours = 1.25
      PaymentService.new(client, "test_prep", hours).charge!("tok_visa")

      expect(subject).to eq(client.reload.test_prep_credit - hours)
    end
  end
end
