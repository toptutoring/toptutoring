class Lead < ApplicationRecord
  belongs_to :subject
  validates :phone_number,
    phone: { possible: true, country_specifier: -> lead { lead.country_code } },
    on: :create
  validates_presence_of :first_name, :last_name, :email, :zip, :comments

  scope :active, -> { where(archived: false) }

  def full_name
    first_name + " " + last_name
  end
end
