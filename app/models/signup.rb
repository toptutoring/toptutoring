class Signup < ActiveRecord::Base
  include ShowSubjectName

  belongs_to :user
  validates_inclusion_of :student, :in => [true, false]
end
