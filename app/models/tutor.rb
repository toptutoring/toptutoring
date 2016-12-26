class Tutor < ActiveRecord::Base
  SAT = "SAT"
  PSAT = "PSAT"
  ACTIVITY_TYPE = [SAT, PSAT]

  # Associations
  belongs_to :user
end
