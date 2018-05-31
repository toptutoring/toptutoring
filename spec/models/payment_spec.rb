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

  describe "#card_brand_and_four_digits" do
    it "concats card brand and last four digits of a payment" do
      payment = FactoryBot.create(:payment, :hourly_purchase, last_four: "1234", card_brand: "Visa")
      expect(payment.card_brand_and_four_digits).to eq "Visa ending in ...1234"
    end
  end

  describe "#payer_name" do
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

  describe "#set_rate" do
    let(:client) { FactoryBot.create(:client_user, online_academic_rate_cents: 20_00, online_test_prep_rate_cents: 25_00, in_person_academic_rate_cents: 30_00, in_person_test_prep_rate_cents: 35_00) }
    it "correctly sets rate when rate is missing" do
      payment = FactoryBot.build(:payment, :hourly_purchase, payer: client, rate_cents: nil)
      expect(payment.rate_cents).to eq nil
      payment.set_rate
      expect(payment.rate_cents).to eq 20_00
    end

    it "correctly sets rate when rate is missing for online_test_prep" do
      payment = FactoryBot.build(:payment, :hourly_purchase, payer: client, hours_type: "online_test_prep", rate_cents: nil)
      expect(payment.rate_cents).to eq nil
      payment.set_rate
      expect(payment.rate_cents).to eq 25_00
    end

    it "correctly sets rate when rate is missing for in_person_academic" do
      payment = FactoryBot.build(:payment, :hourly_purchase, payer: client, hours_type: "in_person_academic", rate_cents: nil)
      expect(payment.rate_cents).to eq nil
      payment.set_rate
      expect(payment.rate_cents).to eq 30_00
    end

    it "correctly sets rate when rate is missing for in_person_test_prep" do
      payment = FactoryBot.build(:payment, :hourly_purchase, payer: client, hours_type: "in_person_test_prep", rate_cents: nil)
      expect(payment.rate_cents).to eq nil
      payment.set_rate
      expect(payment.rate_cents).to eq 35_00
    end

    it "does nothing if it is a one time payment" do
      payment = FactoryBot.build(:payment, :one_time_payment, rate_cents: nil)
      expect(payment.rate_cents).to eq nil
      payment.set_rate
      expect(payment.rate_cents).to eq nil
    end
  end

  describe "#set_amount" do
    # Default hours for payments is 2
    it "correctly sets amount when amount is missing" do
      payment = FactoryBot.build(:payment, :hourly_purchase, rate_cents: 20_00, amount_cents: nil)
      expect(payment.amount_cents).to eq nil
      payment.set_amount
      expect(payment.amount_cents).to eq 40_00
    end

    it "correctly sets amount for different rates" do
      payment = FactoryBot.build(:payment, :hourly_purchase, rate_cents: 25_00, amount_cents: nil)
      expect(payment.amount_cents).to eq nil
      payment.set_amount
      expect(payment.amount_cents).to eq 50_00
    end

    it "correctly sets amount for different hours" do
      payment = FactoryBot.build(:payment, :hourly_purchase, rate_cents: 20_00, hours_purchased: 3, amount_cents: nil)
      expect(payment.amount_cents).to eq nil
      payment.set_amount
      expect(payment.amount_cents).to eq 60_00
    end

    it "does nothing if it is a one time payment" do
      payment = FactoryBot.build(:payment, :one_time_payment, amount_cents: 25_00)
      expect(payment.amount_cents).to eq 25_00
      payment.set_amount
      expect(payment.amount_cents).to eq 25_00
    end
  end

  describe "#set_default_description" do
    it "correctly sets description for payments" do
      payment = FactoryBot.build(:payment, :hourly_purchase, description: nil)
      expect(payment.description).to eq nil
      payment.set_default_description
      expect(payment.description).to eq "Purchase of 2.0 Online academic hours."
    end

    it "correctly sets description for payments for different hours" do
      payment = FactoryBot.build(:payment, :hourly_purchase, hours_purchased: 4.75, description: nil)
      expect(payment.description).to eq nil
      payment.set_default_description
      expect(payment.description).to eq "Purchase of 4.75 Online academic hours."
    end

    it "correctly sets description for payments for different hour types" do
      payment = FactoryBot.build(:payment, :hourly_purchase, hours_type: "in_person_test_prep", description: nil)
      expect(payment.description).to eq nil
      payment.set_default_description
      expect(payment.description).to eq "Purchase of 2.0 In person test prep hours."
    end

    it "does nothing if it is a one time payment" do
      description = "A description"
      payment = FactoryBot.build(:payment, :one_time_payment, description: description)
      expect(payment.description).to eq description
      payment.set_default_description
      expect(payment.description).to eq description
    end
  end

  describe "#fully_refunded?" do
    it "returns true if payment is fully refunded" do
      payment = FactoryBot.create(:payment, :hourly_purchase, hours_purchased: 5)
      FactoryBot.create(:refund, payment: payment, hours: 5)
      expect(payment.fully_refunded?).to eq true
    end

    it "returns true if payment is fully refunded by multiple refunds" do
      payment = FactoryBot.create(:payment, :hourly_purchase, hours_purchased: 4)
      FactoryBot.create(:refund, payment: payment, hours: 3)
      FactoryBot.create(:refund, payment: payment, hours: 1)
      expect(payment.fully_refunded?).to eq true
    end

    it "returns false if payment is not fully refunded" do
      payment = FactoryBot.create(:payment, :hourly_purchase, hours_purchased: 6)
      FactoryBot.create(:refund, payment: payment, hours: 5)
      expect(payment.fully_refunded?).to eq false
    end

    it "returns false if payment has never been refunded" do
      payment = FactoryBot.create(:payment, :hourly_purchase, hours_purchased: 6)
      expect(payment.fully_refunded?).to eq false
    end
  end

  describe "#refundable_hours" do
    it "returns remaining hours that can be refunded" do
      payment = FactoryBot.create(:payment, :hourly_purchase, hours_purchased: 5)
      FactoryBot.create(:refund, payment: payment, hours: 4)
      expect(payment.refundable_hours).to eq 1
    end

    it "returns 0 if fully refunded" do
      payment = FactoryBot.create(:payment, :hourly_purchase, hours_purchased: 1)
      FactoryBot.create(:refund, payment: payment, hours: 1)
      expect(payment.refundable_hours).to eq 0
    end

    it "handles multiple refunds when calculating refundable hours" do
      payment = FactoryBot.create(:payment, :hourly_purchase, hours_purchased: 5.75)
      FactoryBot.create(:refund, payment: payment, hours: 1)
      FactoryBot.create(:refund, payment: payment, hours: 1.25)
      expect(payment.refundable_hours).to eq 3.5
    end

    it "returns nil if payment was a one time payment" do
      payment = FactoryBot.create(:payment, :one_time_payment)
      expect(payment.refundable_hours).to eq nil
    end
  end
end
