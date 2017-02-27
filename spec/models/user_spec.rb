RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  context "when user is parent" do
    before {
      allow(subject).to receive(:student).and_return(FactoryGirl.create(:student))
    }
    it { should have_one(:student) }
    it { should accept_nested_attributes_for(:student)}
  end

  context "when user is tutor" do
    before {
      allow(subject).to receive(:tutor).and_return(FactoryGirl.create(:tutor))
    }
    it { should have_one(:tutor) }
    it { should accept_nested_attributes_for(:tutor) }
  end

end
