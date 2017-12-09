class Subject < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :engagements
  has_many :signups
  has_and_belongs_to_many :tutor_accounts

  enum academic_type: { academic: "academic", 
                        test_prep: "test_prep" }
end
