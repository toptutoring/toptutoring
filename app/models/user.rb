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
  has_many :emails, class_name: "Email", foreign_key: "tutor_id"

  attr_encrypted :access_token, key: ENV.fetch("ENCRYPTOR_KEY")
  attr_encrypted :refresh_token, key: ENV.fetch("ENCRYPTOR_KEY")

  # Validation #
  validates_uniqueness_of :email
  validates_presence_of :name

  # Scopes #
  scope :customer, ->(customer_id) { where(customer_id: customer_id) }
  scope :with_tutor_role, -> { joins(:tutor) }
  scope :with_parent_role, -> { joins(:student) }
  scope :with_external_auth, -> { where.not(encrypted_access_token: nil) & where.not(encrypted_refresh_token: nil) }
  scope :tutors_with_external_auth, -> { joins(:tutor) & User.with_external_auth }
  scope :admin_payer, -> { where(admin: true) & where(demo: false) }

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

  def is_director?
    tutor.present? && tutor.director?
  end

  def is_tutor?
    tutor.present?
  end

  def is_parent?
    student.present?
  end

  def is_customer?
    customer_id.present?
  end

  def has_external_auth?
    access_token.present? && refresh_token.present?
  end

  def valid_token?
    Time.zone.at(token_expires_at) > Time.current
  end

  def currency_balance
    balance * tutor.hourly_rate
  end

  def hourly_balance
    if assignment && assignment.active?
      balance.to_f / assignment.hourly_rate
    end
  end
end
