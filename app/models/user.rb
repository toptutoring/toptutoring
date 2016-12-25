class User < ActiveRecord::Base
  include Clearance::User

  # Associations
  has_one :student, dependent: :destroy
  accepts_nested_attributes_for :student
  has_one :tutor, dependent: :destroy
  accepts_nested_attributes_for :tutor

  # Roles
  def tutor?
    self.tutor.present?
  end

  def parent?
    self.student.present?
  end

  def customer?
    self.customer_id.present?
  end
end
