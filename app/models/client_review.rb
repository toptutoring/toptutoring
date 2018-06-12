class ClientReview < ApplicationRecord
  belongs_to :client_account
  validates_presence_of :stars
end
