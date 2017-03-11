class User < ActiveRecord::Base
  include Clearance::User

  # Associations
  has_one :student_info, dependent: :destroy
  accepts_nested_attributes_for :student_info
  has_one :tutor_info, dependent: :destroy
  accepts_nested_attributes_for :tutor_info
  has_many :students, class_name: "User", foreign_key: "client_id"
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  has_many :payments
  has_many :assignments, class_name: "Assignment", foreign_key: "tutor_id"
  has_one :assignment, class_name: "Assignment", foreign_key: "student_id"
  has_many :invoices, class_name: "Invoice", foreign_key: "tutor_id"
  has_many :emails, class_name: "Email", foreign_key: "tutor_id"
  has_many :user_roles
  has_many :roles, through: :user_roles
  attr_encrypted :access_token, key: ENV.fetch("ENCRYPTOR_KEY")
  attr_encrypted :refresh_token, key: ENV.fetch("ENCRYPTOR_KEY")

  # Validation #
  validates_uniqueness_of :email
  validates_presence_of :name

  # Scopes #
  scope :customer, ->(customer_id) { where(customer_id: customer_id) }
  # Refactor these
  scope :with_tutor_role, -> { joins(:tutor) }
  scope :with_client_role, -> { joins(:student) }
  scope :with_external_auth, -> { where.not(encrypted_access_token: nil) & where.not(encrypted_refresh_token: nil) }
  scope :tutors_with_external_auth, -> { joins(:tutor) & User.with_external_auth }
  scope :admin_payer, -> { where(admin: true) & where(demo: false) }
  scope :enabled, -> { where(access_state: "enabled") }
  scope :assigned, -> { joins(:assignment).merge(Assignment.active) }
  scope :admin_and_directors, -> { joins(:roles).where("roles.name = ? OR roles.name = ?", "admin", "director").distinct }

  #### State Machine ####
  state_machine :access_state, :initial => :disabled do
    event :enable do
      transition :disabled => :enabled
    end

    event :disable do
      transition :enabled => :disabled
    end
  end

  def roles=(roles)
    if roles.is_a? Array
      roles.each do |role|
        role_id =  Role.find_by_name(role).id
        self.user_roles.build(role_id: role_id)
      end
    else
      role_id =  Role.find_by_name(roles).id
      self.user_roles.build(role_id: role_id)
    end
  end

  def has_role?(role)
    roles.any? { |r| r.name == role }
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
