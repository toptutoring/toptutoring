class Tutor < ActiveRecord::Base
  TEST_PREP = "Test Prep"
  ACADEMIC = "Academic"
  ACADEMIC_TYPE = [TEST_PREP, ACADEMIC]

  # Associations
  belongs_to :user

  # Validations
  validates_presence_of :academic_type
end
