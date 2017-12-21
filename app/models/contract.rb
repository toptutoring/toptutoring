class Contract < ApplicationRecord
  # Associations
  belongs_to :account, polymorphic: true

  # Validations
  validates_presence_of :hourly_rate, :numericality => { :greater_than_or_equal_to => 0 }

  # Monetize Hourly Rate
  monetize :hourly_rate_cents
end
