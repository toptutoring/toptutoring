RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  context "when user is parent" do
    before {
      allow(subject).to receive(:student).and_return(FactoryGirl.create(:student_user))
    }
    it { should have_one(:student) }
    it { should accept_nested_attributes_for(:student)}
  end

  context "when user is tutor" do
    before {
      allow(subject).to receive(:tutor_info).and_return(FactoryGirl.create(:tutor_info))
    }
    it { should have_one(:tutor_info) }
    it { should accept_nested_attributes_for(:tutor_info) }
  end

end
