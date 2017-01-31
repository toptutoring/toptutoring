class User < ActiveRecord::Base
  include Clearance::User

  # Associations
  has_one :student, dependent: :destroy
  accepts_nested_attributes_for :student
  has_one :tutor, dependent: :destroy
  accepts_nested_attributes_for :tutor
  has_many :payments
  has_many :assignments, class_name: "Assignment", foreign_key: "tutor_id"
  has_one :assignment, class_name: "Assignment", foreign_key: "student_id"
  has_many :invoices, class_name: "Invoice", foreign_key: "tutor_id"

  attr_encrypted :access_token, key: ENV.fetch("ENCRYPTOR_KEY")
  attr_encrypted :refresh_token, key: ENV.fetch("ENCRYPTOR_KEY")

  # Validation #
  validates_uniqueness_of :email

  # Scopes #
  scope :customer, ->(customer_id) { where(customer_id: customer_id) }
  scope :with_external_auth, -> { where.not(encrypted_access_token: nil) & where.not(encrypted_refresh_token: nil) }
  scope :tutors_with_external_auth, -> { joins(:tutor) & User.with_external_auth }
  scope :tutors_for_director_with_external_auth, -> { joins(:tutor).where('tutors.director = ?', false) & User.with_external_auth }

  #### State Machine ####

  state_machine :access_state, :initial => :disabled do
    event :enable do
      transition :disabled => :enabled
    end

    event :disable do
      transition :enabled => :disabled
    end
  end

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
