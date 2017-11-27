class Subject < ActiveRecord::Base
  validates_uniqueness_of :name
  enum tutoring_type: { academic: "academic", 
                        test_prep: "test_prep" }

  belongs_to :user
  has_many :engagements

  def academic_type
    academic? ? "Academic" : "Test Prep"
  end

  def academic?
    tutoring_type == "academic"
  end

  def test_prep?
    tutoring_type == "test_prep"
  end
end
