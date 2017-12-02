class Subject < ActiveRecord::Base
  validates_uniqueness_of :name
  enum tutoring_type: { academic: "academic", 
                        test_prep: "test_prep" }

  has_many :tutor_profiles
  has_many :users, through: :tutor_profiles

  def academic_type
    academic? ? "Academic" : "Test Prep"
  end
end
