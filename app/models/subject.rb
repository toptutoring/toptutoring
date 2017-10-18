class Subject < ActiveRecord::Base
  validates_uniqueness_of :name
  enum tutoring_type: { academic: "academic", 
                        test_prep: "test_prep" }

  belongs_to :user
end
