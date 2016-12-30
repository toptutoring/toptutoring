class Tutor < ActiveRecord::Base
  SAT = "SAT"
  PSAT = "PSAT"
  ACADEMIC_TYPE = [SAT, PSAT]

  # Associations
  belongs_to :user

end
