class Payment < ActiveRecord::Base
  belongs_to :payer
  belongs_to :payee

  scope :from_parents, ->{ where(destination: nil) }

  def payer
    if self.destination.nil?
      User.find_by(customer_id: self.source)
    else
      User.find_by(auth_uid: self.source)
    end
  end
end
