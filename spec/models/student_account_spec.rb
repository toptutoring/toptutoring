require 'rails_helper'

RSpec.describe StudentAccount, type: :model do
  it { should validate_presence_of(:client_account) }
  it { should validate_presence_of(:name) }

  let(:student) { FactoryBot.create(:student_user) }

  describe "#academic_types_engaged" do
    it "returns only the types engaged" do
      subject = student.student_account
      FactoryBot.create(:engagement, student_account: subject)

      expect(subject.academic_types_engaged).to contain_exactly("academic")

      FactoryBot.create(:engagement, student_account: subject, subject: FactoryBot.create(:subject, academic_type: "test_prep"))

      expect(subject.academic_types_engaged).to contain_exactly("academic", "test_prep")
    end
  end
end
