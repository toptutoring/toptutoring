class Suggestion < ApplicationRecord
  belongs_to :engagement 

  validates :number_of_hours, presence: true, :numericality =>{ :only_integer => true, :greater_than => 0 }
end
