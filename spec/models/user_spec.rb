require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  context "when user is tutor" do
    before {
      allow(subject).to receive(:contract).and_return(FactoryGirl.create(:contract))
    }
    it { should have_one(:contract) }
    it { should accept_nested_attributes_for(:contract) }
  end

  describe ".with_pending_invoices" do
    let(:tutor_with_pending) { FactoryGirl.create(:tutor_user, name: 'TutorWithPending') }
    let(:tutor_without_pending) { FactoryGirl.create(:tutor_user, name: 'TutorWithOutPending') }

    it 'returns users with pending invoices' do
      FactoryGirl.create(:invoice, submitter: tutor_with_pending)
      FactoryGirl.create(:invoice, submitter: tutor_without_pending, status: 'paid')
      result = User.with_pending_invoices('by_tutor')

      expect(result.count).to eq(1)
      expect(result.first.name).to eq tutor_with_pending.name
    end

    it 'returns one user when they have multiple invoices' do
      FactoryGirl.create(:invoice, submitter: tutor_with_pending)
      FactoryGirl.create(:invoice, submitter: tutor_with_pending)
      FactoryGirl.create(:invoice, submitter: tutor_with_pending)
      result = User.with_pending_invoices('by_tutor')

      expect(result.count).to eq(1)
      expect(result.first.name).to eq tutor_with_pending.name
    end

    it 'returns users with pending invoices of the given type' do
      FactoryGirl.create(:invoice, submitter: tutor_with_pending)
      FactoryGirl.create(:invoice, submitter: tutor_without_pending, submitter_type: 'by_contractor')
      result = User.with_pending_invoices('by_tutor')

      expect(result.count).to eq(1)
      expect(result.first.name).to eq tutor_with_pending.name
    end
  end
end
