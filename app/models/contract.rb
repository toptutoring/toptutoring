class Contract < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations 
  validates_presence_of :hourly_rate, :numericality => { :greater_than => 0 }
end
