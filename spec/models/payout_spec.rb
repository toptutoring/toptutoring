require 'rails_helper'

RSpec.describe Payout, type: :model do
  it { should belong_to(:receiving_account) }
  it { should belong_to(:approver) }
  it { should validate_numericality_of(:amount_cents) }
  it { should_not allow_value(0).for(:amount_cents) }

  describe "#payee" do
    let(:tutor) { FactoryBot.create(:tutor_user) }
    let(:payout) { FactoryBot.create(:payout, receiving_account: tutor.tutor_account) }

    it "returns the user who received payment" do
      subject = payout.payee

      expect(subject).to be tutor
    end
  end
end
