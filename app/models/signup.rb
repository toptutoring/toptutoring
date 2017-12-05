class Signup < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject
  validates_inclusion_of :student, :in => [true, false]
end
