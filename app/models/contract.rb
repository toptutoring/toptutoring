class Contract < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates_presence_of :hourly_rate, :numericality => { :greater_than_or_equal_to => 0 }
end