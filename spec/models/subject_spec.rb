require "rails_helper"

RSpec.describe Subject, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:signups) }
  describe ".academic_type" do
    it "returns academic if tutoring type is academic" do
      academic_subject = FactoryBot.create(:subject, academic_type: "academic")
      return_value = academic_subject.academic_type
      
      expect(return_value).to eq("academic")
    end

    it "returns Test Prep if tutoring type is test_prep" do
      academic_subject = FactoryBot.create(:subject, academic_type: "test_prep")
      return_value = academic_subject.academic_type
      
      expect(return_value).to eq("test_prep")
    end
  end
end
