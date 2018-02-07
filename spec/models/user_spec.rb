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
end
