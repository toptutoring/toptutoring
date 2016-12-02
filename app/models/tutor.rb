class Tutor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable

  VAT = "SAT"
  SMTH = "PSAT"
  ACTIVITY_TYPE=[VAT, SMTH]

  # Associations
  belongs_to :user

  # Validations
  validates_presence_of :subject, :activity_type
end
