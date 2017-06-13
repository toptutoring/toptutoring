class CreditCard < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :customer_id
end
