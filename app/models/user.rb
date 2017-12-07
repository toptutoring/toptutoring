class User < ActiveRecord::Base
  include Clearance::User

  # Associations
  has_one :contract, dependent: :destroy
  accepts_nested_attributes_for :contract
  has_one :signup, dependent: :destroy
  accepts_nested_attributes_for :signup
  has_many :students, class_name: "User", foreign_key: "client_id"
  has_one :student_account
  has_one :client_account
  has_one :tutor_account
  has_many :student_accounts, through: :client_accounts
  accepts_nested_attributes_for :students
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  has_many :tutor_engagements, class_name: "Engagement", foreign_key: "tutor_id"
  has_many :invoices, ->(user) { unscope(:where).where("submitter_id = ? OR client_id = ?", user.id, user.id) }
  has_many :emails, class_name: "Email", foreign_key: "tutor_id", dependent: :destroy
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :tutor_profiles
  has_many :subjects, through: :tutor_profiles
  has_many :feedbacks
  has_many :timesheets
  has_many :payments_received, class_name: "Payment", foreign_key: "payee_id"
  has_many :payments_made, class_name: "Payment", foreign_key: "payer_id"
  has_many :payments_approved, class_name: "Payment", foreign_key: "approver_id"
  accepts_nested_attributes_for :subjects
  attribute :access_token
  attr_encrypted :access_token, key: ENV.fetch("ENCRYPTOR_KEY")
  attribute :refresh_token
  attr_encrypted :refresh_token, key: ENV.fetch("ENCRYPTOR_KEY")

  # Validation #
  validates_presence_of :name
  validates_length_of :phone_number, minimum: 3, allow_nil: true
  validate :credits_must_be_by_quarter_hours

  def credits_must_be_by_quarter_hours
    return if academic_credit % 0.25 == 0.0 && test_prep_credit % 0.25 == 0.0
    errors.add(:credits, "must be in quarter hours")
  end

  # Scopes #
  scope :customer, ->(customer_id) { where(customer_id: customer_id) }
  scope :tutors, -> { joins(:roles).where(roles: { name: "tutor" }).distinct }
  scope :contractors, -> { joins(:roles).where(roles: { name: "contractor" }).distinct }
  scope :clients, -> { joins(:roles).where(roles: { name: "client" }).distinct }
  scope :students, -> { joins(:roles).where(roles: { name: "student" }).distinct }
  scope :admin, -> { joins(:roles).where(roles: { name: "admin" }).distinct.first || [] }
  scope :with_external_auth, -> { where.not(encrypted_access_token: nil) & where.not(encrypted_refresh_token: nil) }
  scope :tutors_with_external_auth, -> { tutors.with_external_auth }
  scope :enabled, -> { where(access_state: "enabled") }
  scope :assigned, -> { joins(:engagement).merge(Engagement.active) }
  scope :admin_and_directors, -> { joins(:roles).where("roles.name = ? OR roles.name = ?", "admin", "director").distinct }
  scope :all_without_admin, -> { joins(:roles).where("roles.name != ?", "admin").distinct }

  # Monetize Implementation for client
  monetize :academic_rate_cents, :numericality => { :greater_than_or_equal_to => 0 }
  monetize :test_prep_rate_cents, :numericality => { :greater_than_or_equal_to => 0 }

  #### State Machine ####
  state_machine :access_state, :initial => :disabled do
    event :enable do
      transition :disabled => :enabled
    end

    event :disable do
      transition :enabled => :disabled
    end
  end

  #### Setters ####

  def dwolla_access_token=(value)
    self.encrypted_access_token = nil
    self.encrypted_access_token_iv = nil
    self.access_token=value
  end

  def dwolla_refresh_token=(value)
    self.encrypted_refresh_token = nil
    self.encrypted_refresh_token_iv = nil
    self.refresh_token=value
  end

  def reset_dwolla_tokens
    self.encrypted_refresh_token = nil
    self.encrypted_refresh_token_iv = nil
    self.encrypted_access_token = nil
    self.encrypted_access_token_iv = nil
    self.token_expires_at = nil
    self.save!
  end

  def has_role?(role)
    roles.find_by_name(role)
  end

  def is_customer?
    customer_id.present?
  end

  def requires_dwolla?
    roles.where(roles: { name: ['director', 'tutor', 'contractor', 'admin'] }).any?
  end

  def has_valid_dwolla?
    auth_uid.present?
  end

  def valid_token?
    token_expires_at && Time.zone.at(token_expires_at) > Time.current
  end

  def credit_status(invoice)
    invoice.engagement.academic? ? academic_credit : test_prep_credit
  end

  def is_student?
    signup&.student
  end

  def notify_bugsnag
    if Rails.env.production?
      Bugsnag.notify("OpenSSL::Cipher::CipherError: Invalid tokens for user #{id}")
    end
  end

  def self.with_pending_invoices(type)
    join_sql = "JOIN invoices ON users.id = invoices.submitter_id"
    joins(join_sql).where(invoices: {status: 'pending', submitter_type: type}).distinct
  end
end
