class Subject < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :engagements
  has_many :signups
  has_and_belongs_to_many :tutor_accounts
  has_many :test_scores, dependent: :destroy

  enum academic_type: { academic: "academic",
                        test_prep: "test_prep" }
  enum category: { english: "english",
                   foreign_language: "foreign_language",
                   history: "history",
                   math: "math",
                   science: "science",
                   test_preparation: "test_preparation",
                   other: "other" }
end
