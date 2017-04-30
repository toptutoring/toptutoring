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

end
