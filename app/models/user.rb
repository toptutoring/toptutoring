class User < ActiveRecord::Base
  include Clearance::User

  # Associations
  has_one :student_info, dependent: :destroy
  accepts_nested_attributes_for :student_info
  has_one :tutor_info, dependent: :destroy
  accepts_nested_attributes_for :tutor_info
  has_many :children, class_name: "User", foreign_key: "parent_id"
  belongs_to :parent, class_name: "User", foreign_key: "parent_id"
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
  scope :enabled, -> { where(access_state: "enabled") }
  scope :assigned, -> { joins(:assignment).merge(Assignment.active) }
  scope :admin_and_directors, -> { left_joins(:tutor).where('users.admin=? OR tutors.director=?', true, true) }

  #### State Machine ####
  state_machine :access_state, :initial => :disabled do
    event :enable do
      transition :disabled => :enabled
    end

    event :disable do
      transition :enabled => :disabled
    end
  end

  ### Roles ###
  ROLES = %i[admin director tutor parent student]

  # This will perform the necessary bitwise operations to translate an array of roles into the integer field.
  def roles=(roles)
    roles = [*roles].map { |r| r.to_sym }
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def has_role?(role)
    roles.include?(role)
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
