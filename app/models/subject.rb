class Subject < ActiveRecord::Base
  validates_uniqueness_of :name
  enum academic_type: { academic: "academic", 
                        test_prep: "test_prep" }

  belongs_to :user
  has_many :engagements
end
