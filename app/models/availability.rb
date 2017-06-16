class Availability < ApplicationRecord
  belongs_to :engagement

  default_scope { order(:id) }
end
