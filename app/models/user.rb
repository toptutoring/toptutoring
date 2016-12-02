class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Associations
  has_one :student, :dependent => :destroy
  accepts_nested_attributes_for :student
  has_one :tutor, :dependent => :destroy
  accepts_nested_attributes_for :tutor

  # Validations
  validates_presence_of :name, :email, :phone_number

  def has_card_info?
    self.customer_id
  end
end
