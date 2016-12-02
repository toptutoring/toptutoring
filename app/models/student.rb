class Student < ActiveRecord::Base
  belongs_to :user

  # Validations
  validates_presence_of :name, :email, :phone_number
end
