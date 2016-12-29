class User < ActiveRecord::Base
  include Clearance::User

  # Associations
  has_one :student, dependent: :destroy
  accepts_nested_attributes_for :student
  has_one :tutor, dependent: :destroy
  accepts_nested_attributes_for :tutor
  has_many :payments

  attr_encrypted :access_token, key: ENV.fetch("ENCRYPTOR_KEY")
  attr_encrypted :refresh_token, key: ENV.fetch("ENCRYPTOR_KEY")

  # Roles

  def director?
    tutor.present? && tutor.director?
  end

  def tutor?
    tutor.present?
  end

  def parent?
    student.present?
  end

  def customer?
    customer_id.present?
  end

  def has_external_auth?
    access_token.present? && refresh_token.present?
  end

  def valid_token?
    Time.zone.at(token_expires_at) > Time.current
  end
end