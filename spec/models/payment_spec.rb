require "rails_helper"

RSpec.describe Payment, type: :model do
  context "for logged in stripe payments" do
    before { allow(subject).to receive(:customer_id).and_return('xxx') }
    it { should belong_to(:payer) }
    it { should validate_presence_of(:payer_id) }
    it { should validate_presence_of(:hours_type) }
    it { should validate_presence_of(:card_holder_name) }
    it { should validate_presence_of(:last_four) }
    it { should validate_presence_of(:card_brand) }
    it { should validate_numericality_of(:amount_cents) }
    it { should validate_numericality_of(:rate_cents) }
    it { should validate_numericality_of(:hours_purchased) }
    it { should_not allow_value(0).for(:amount_cents) }
    it { should_not allow_value(0).for(:rate_cents) }
    it { should_not allow_value(0).for(:hours_purchased) }
  end
end
