class Suggestion < ApplicationRecord
  belongs_to :engagement 

  validates :number_of_hours, presence: true, :numericality =>{ :greater_than => 0 }
end
