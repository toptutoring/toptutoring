require "rails_helper"

RSpec.describe Subject, type: :model do
  describe ".academic_type" do
    it "returns Academic if tutoring type is academic" do
      academic_subject = FactoryGirl.create(:subject, tutoring_type: "academic")
      return_value = academic_subject.academic_type
      
      expect(return_value).to eq("Academic")
    end

    it "returns Test Prep if tutoring type is test_prep" do
      academic_subject = FactoryGirl.create(:subject, tutoring_type: "test_prep")
      return_value = academic_subject.academic_type
      
      expect(return_value).to eq("Test Prep")
    end
  end
end
