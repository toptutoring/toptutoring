require "rails_helper"

RSpec.describe Payment, type: :model do
  context "for logged in stripe payments" do
    before { allow(subject).to receive(:customer_id).and_return('xxx') }
    it { should belong_to(:payer) }
    it { should validate_presence_of(:payer_id) }
    it { should validate_numericality_of(:amount_cents) }
    it { should_not allow_value(0).for(:amount_cents) }
  end
end
