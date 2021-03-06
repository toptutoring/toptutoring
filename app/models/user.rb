class User < ActiveRecord::Base
  include Clearance::User
  before_create :add_unique_token

  # Associations
  has_one :signup, dependent: :destroy
  accepts_nested_attributes_for :signup
  has_one :stripe_account
  has_many :students, class_name: "User", foreign_key: "client_id"
  has_one :student_account, dependent: :destroy
  has_one :client_account, dependent: :destroy
  accepts_nested_attributes_for :client_account
  has_one :tutor_account, dependent: :destroy
  accepts_nested_attributes_for :tutor_account
  has_one :contractor_account, dependent: :destroy
  accepts_nested_attributes_for :students
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  has_many :referrals, class_name: "User", foreign_key: "referrer_id"
  belongs_to :referrer, class_name: "User", foreign_key: "referrer_id"
  has_many :invoices, foreign_key: "submitter_id"
  has_many :pending_invoices, -> { where(status: "pending") }, class_name: "Invoice", foreign_key: "submitter_id"
  has_many :emails, class_name: "Email", foreign_key: "tutor_id", dependent: :destroy
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :feedbacks
  has_many :timesheets
  has_many :payments_made, class_name: "Payment", foreign_key: "payer_id"
  has_many :refunds, through: :payments_made
  has_many :approved_payouts, class_name: "Payout", foreign_key: "approver_id"
  attribute :access_token
  attr_encrypted :access_token, key: ENV.fetch("ENCRYPTOR_KEY")
  attribute :refresh_token
  attr_encrypted :refresh_token, key: ENV.fetch("ENCRYPTOR_KEY")

  # Validation #
  validates :phone_number,
    phone: { possible: true, country_specifier: -> user { user.country_code } },
    if: :phone_number_changed?
  validates_presence_of :first_name, :email
  validates :email, uniqueness: true, on: :create
  validates_presence_of :phone_number, :country_code, on: :create
  validate :credits_must_be_by_quarter_hours

  attr_accessor :switch_to_student

  def credits_must_be_by_quarter_hours
    return if online_academic_credit % 0.25 == 0.0 && online_test_prep_credit % 0.25 == 0.0 &&
      in_person_academic_credit % 0.25 == 0.0 && in_person_test_prep_credit % 0.25 == 0.0
    errors.add(:credits, "must be in quarter hours")
  end

  # Scopes #
  scope :active, -> { where(archived: false) }
  scope :tutors, -> { joins(:roles).where(roles: { name: "tutor" }).distinct }
  scope :contractors, -> { joins(:roles).where(roles: { name: "contractor" }).distinct }
  scope :clients, -> { joins(:roles).where(roles: { name: "client" }).distinct }
  scope :students, -> { joins(:roles).where(roles: { name: "student" }).distinct }
  scope :admin, -> { joins(:roles).where(roles: { name: "admin" }).distinct.first || [] }
  scope :with_dwolla_auth, -> { where.not(auth_uid: nil) }
  scope :tutors_with_dwolla_auth, -> { tutors.with_dwolla_auth }
  scope :enabled, -> { where(access_state: "enabled") }
  scope :assigned, -> { joins(:engagement).merge(Engagement.active) }
  scope :admin_and_directors, -> { joins(:roles).where("roles.name = ? OR roles.name = ?", "admin", "director").distinct }
  scope :all_without_admin, -> { joins(:roles).where("roles.name != ?", "admin").distinct }
  scope :view_order, -> { order(:archived, :first_name, :last_name, :id) }

  # Monetize Implementation for client
  monetize :online_academic_rate_cents, :numericality => { :greater_than_or_equal_to => 0 }
  monetize :online_test_prep_rate_cents, :numericality => { :greater_than_or_equal_to => 0 }
  monetize :in_person_academic_rate_cents, :numericality => { :greater_than_or_equal_to => 0 }
  monetize :in_person_test_prep_rate_cents, :numericality => { :greater_than_or_equal_to => 0 }

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

  def add_unique_token
    self.unique_token = SecureRandom.hex(3)
  end

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

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def has_role?(role)
    roles.find_by_name(role)
  end

  def admin?
    has_role?("admin")
  end

  def requires_dwolla?
    roles.where(roles: { name: ["director", "tutor", "contractor", "admin"] }).any?
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

  def phone_formatted(format = :national)
    Phonelib.parse(phone_number, country_code).send(format)
  end

  def rate_set?(type)
    send("#{type}_rate") > 0
  end

  def self.with_pending_invoices_attributes(type)
    account_type = type == "by_tutor" ? :tutor_account : :contractor_account
    select_query = "users.*, SUM(invoices.submitter_pay_cents) " \
      "AS amount_cents, array_agg(invoices.id ORDER BY invoices.id) " \
      "AS invoice_to_pay_ids, SUM(invoices.hours) AS invoice_hours"
    User.includes(account_type)
        .joins(:pending_invoices)
        .where(invoices: { submitter_type: type })
        .group(:id).select(select_query)
  end
end
