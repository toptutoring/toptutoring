require "rails_helper"

describe StripeRefundService do
    let(:payment) { FactoryBot.create(:payment, :hourly_purchase) }
    let(:refund) { FactoryBot.build(:refund, payment: payment) }

  describe "#process_refund!" do
    it "returns true when succesful" do
      subject = StripeRefundService.new(payment, refund)
      expect(subject.process_refund!).to eq true
    end

    it "saves refund to db when successful" do
      subject = StripeRefundService.new(payment, refund)
      subject.process_refund!
      expect(refund.persisted?).to eq true
    end

    it "updates client credit" do
      hours = 2
      refund.hours = hours
      subject = StripeRefundService.new(payment, refund)
      expect { subject.process_refund! }.to change { payment.payer.online_academic_credit }.by(hours * -1)
    end

    it "updates client credit for different hour types" do
      hours = 2.5
      refund.hours = hours
      payment.hours_type = "in_person_test_prep"
      subject = StripeRefundService.new(payment, refund)
      expect { subject.process_refund! }.to change { payment.payer.in_person_test_prep_credit }.by(hours * -1)
    end

    it "updates payment status to refunded" do
      expect(payment.status).to eq "succeeded"
      subject = StripeRefundService.new(payment, refund)
      subject.process_refund!
      expect(payment.reload.status).to eq "refunded"
    end

=begin
  There should be a test for when refund amount is greater than refundable amount on the payment.
  However, Stripe is stubbed in testing and will always return a successful refund.
  Therefore, this aspect of refunds was directly tested by hand to ensure that no refund was able to be created that is greater than the original payment amount.
=end
  end
end
