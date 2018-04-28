require "rails_helper"

RSpec.describe Payment, type: :model do
  context "hourly purchase" do
    before { allow(subject).to receive(:one_time).and_return(false) }
    it { should belong_to(:payer) }
    it { should belong_to(:stripe_account) }
    it { should validate_presence_of(:payer_id) }
    it { should validate_presence_of(:hours_type) }
    it { should validate_numericality_of(:amount_cents) }
    it { should validate_numericality_of(:rate_cents) }
    it { should validate_numericality_of(:hours_purchased) }
    it { should_not allow_value(0).for(:amount) }
    it { should_not allow_value(0).for(:rate) }
    it { should_not allow_value(0).for(:hours_purchased) }
    it { should_not validate_presence_of(:payer_email) }
  end

  context "one time payment" do
    before { allow(subject).to receive(:one_time).and_return(true) }
    it { should validate_presence_of(:payer_email) }
    it { should_not validate_presence_of(:payer_id) }
    it { should_not validate_presence_of(:hours_type) }
    it { should validate_numericality_of(:amount_cents) }
    it { should_not validate_presence_of(:rate_cents) }
    it { should_not validate_numericality_of(:hours_purchased) }
    it { should_not allow_value(0).for(:amount) }
  end

  describe ".card_brand_and_four_digits" do
    it "concats card brand and last four digits of a payment" do
      payment = FactoryBot.create(:payment, :hourly_purchase, last_four: "1234", card_brand: "Visa")
      expect(payment.card_brand_and_four_digits).to eq "Visa ending in ...1234"
    end
  end

  describe ".payer_name" do
    context "one time payment" do
      it "returns card_holder_name" do
        payment = FactoryBot.create(:payment, :one_time_payment)
        name = payment.card_holder_name
        expect(payment.payer_name).to eq name
      end
    end

    context "hourly purchase" do
      it "returns payer name" do
        payment = FactoryBot.create(:payment, :hourly_purchase)
        name = payment.payer.full_name
        expect(payment.payer_name).to eq name
      end
    end
  end
end
