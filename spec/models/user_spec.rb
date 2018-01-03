require "rails_helper"

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  describe "updating user with no phone number" do
    let(:user) { FactoryBot.create(:client_user, :invalid_record, phone_number: nil) }

    it "is skips presence of validation for phone number" do
      user.name = "Changed Name"
      expect(user.valid?).to be true
    end

    it "still validates other params" do
      user.name = nil
      expect(user.valid?).to be false
    end
  end

  describe ".with_pending_invoices" do
    let(:tutor_with_pending) { FactoryBot.create(:tutor_user, name: "TutorWithPending") }
    let(:tutor_without_pending) { FactoryBot.create(:tutor_user, name: "TutorWithOutPending") }

    it "returns users with pending invoices" do
      FactoryBot.create(:invoice, submitter: tutor_with_pending)
      FactoryBot.create(:invoice, submitter: tutor_without_pending, status: "paid")
      result = User.with_pending_invoices("by_tutor")

      expect(result.count).to eq(1)
      expect(result.first.name).to eq tutor_with_pending.name
    end

    it "returns one user when they have multiple invoices" do
      FactoryBot.create(:invoice, submitter: tutor_with_pending)
      FactoryBot.create(:invoice, submitter: tutor_with_pending)
      FactoryBot.create(:invoice, submitter: tutor_with_pending)
      result = User.with_pending_invoices("by_tutor")

      expect(result.count).to eq(1)
      expect(result.first.name).to eq tutor_with_pending.name
    end

    it "returns users with pending invoices of the given type" do
      FactoryBot.create(:invoice, submitter: tutor_with_pending)
      FactoryBot.create(:contractor_account, user: tutor_without_pending)
      FactoryBot.create(:invoice, submitter: tutor_without_pending, submitter_type: "by_contractor")
      result = User.with_pending_invoices("by_tutor")

      expect(result.count).to eq(1)
      expect(result.first.name).to eq tutor_with_pending.name
    end
  end
end
