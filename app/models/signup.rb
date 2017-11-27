class Signup < ActiveRecord::Base
  belongs_to :user
  validates_inclusion_of :student, :in => [true, false]
end
