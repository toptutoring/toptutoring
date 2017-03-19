RSpec.describe User, type: :model do
  before {
    FactoryGirl.create(:role, name: "client")
    FactoryGirl.create(:role, name: "tutor")
  }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  context "when user is tutor" do
    before {
      allow(subject).to receive(:tutor_info).and_return(FactoryGirl.create(:tutor_info))
    }
    it { should have_one(:tutor_info) }
    it { should accept_nested_attributes_for(:tutor_info) }
  end

end
