require 'rails_helper'

RSpec.describe Refund, type: :model do
  context "validations" do
    it { should belong_to(:payment) }
    it { should validate_presence_of(:payment) }
    it { should validate_presence_of(:stripe_refund_id) }
    it { should validate_presence_of(:reason) }
    it { should_not allow_value(0).for(:amount) }
  end

  describe ".set_amount" do
    it "sets amount from hours and payment rate" do
      payment = FactoryBot.create(:payment, :hourly_purchase, rate_cents: 25_00)
      refund = FactoryBot.build(:refund, hours: 1, amount_cents: nil, payment: payment)
      expect(refund.amount_cents).to eq nil
      refund.set_amount
      expect(refund.amount_cents).to eq 25_00
    end

    it "sets amount from hours and payment rate for mulitple hours" do
      payment = FactoryBot.create(:payment, :hourly_purchase, hours_purchased: 3, rate_cents: 30_00, amount_cents: 90_00)
      refund = FactoryBot.build(:refund, hours: 2, amount_cents: nil, payment: payment)
      expect(refund.amount_cents).to eq nil
      refund.set_amount
      expect(refund.amount_cents).to eq 60_00
    end
    
    it "sets amount as remaining balance if refund is for remaining balance" do
      payment = FactoryBot.create(:payment, :hourly_purchase, hours_purchased: 3, rate_cents: 30_00, amount_cents: 90_00)
      FactoryBot.create(:refund, hours: 1, amount_cents: 35_00, payment: payment)
      refund = FactoryBot.build(:refund, hours: 2, amount_cents: nil, payment: payment)
      expect(refund.amount_cents).to eq nil
      refund.set_amount
      expect(refund.amount_cents).to eq 55_00
    end
  end
end
