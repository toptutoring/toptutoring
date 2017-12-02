require 'rails_helper'

RSpec.describe StudentAccount, type: :model do
  it { should validate_presence_of(:client_account) }
  it { should validate_presence_of(:name) }

  let(:student) { FactoryGirl.create(:student_user) }

  describe "#academic_types_engaged" do
    it "returns only the types engaged" do
      subject = student.student_account
      FactoryGirl.create(:engagement, student_account: subject)

      expect(subject.academic_types_engaged).to eq(["academic"])

      FactoryGirl.create(:engagement, student_account: subject, subject: FactoryGirl.create(:subject, academic_type: "test_prep"))

      expect(subject.academic_types_engaged).to eq(["academic", "test_prep"])
    end
  end
end
