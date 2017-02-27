class Student < ActiveRecord::Base
  TEST_PREP = "Test Prep"
  ACADEMIC = "Academic"
  ACADEMIC_TYPE = [TEST_PREP, ACADEMIC]

  belongs_to :user
end
