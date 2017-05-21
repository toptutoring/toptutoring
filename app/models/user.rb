class User < ActiveRecord::Base
  include Clearance::User

  # Associations
  has_one :student_info, dependent: :destroy
  accepts_nested_attributes_for :student_info
  has_one :contract, dependent: :destroy
  accepts_nested_attributes_for :contract
  has_one :client_info, dependent: :destroy
  accepts_nested_attributes_for :client_info
  has_many :students, class_name: "User", foreign_key: "client_id"
  accepts_nested_attributes_for :students
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  has_many :tutor_engagements, class_name: "Engagement", foreign_key: "tutor_id", dependent: :destroy
  has_many :client_engagements, class_name: "Engagement", foreign_key: "client_id", dependent: :destroy
  has_many :student_engagements, class_name: "Engagement", foreign_key: "student_id", dependent: :destroy
  has_many :invoices, class_name: "Invoice", foreign_key: "tutor_id", dependent: :destroy
  has_many :emails, class_name: "Email", foreign_key: "tutor_id", dependent: :destroy
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :tutor_profiles
  has_many :subjects, through: :tutor_profiles
  accepts_nested_attributes_for :subjects
  attr_encrypted :access_token, key: ENV.fetch("ENCRYPTOR_KEY")
  attr_encrypted :refresh_token, key: ENV.fetch("ENCRYPTOR_KEY")

  # Validation #
  validates_presence_of :name

  # Scopes #
  scope :customer, ->(customer_id) { where(customer_id: customer_id) }
  scope :with_tutor_role, -> { joins(:roles).where("roles.name = ?", "tutor").distinct }
  scope :with_client_role, -> { joins(:roles).where("roles.name = ?", "client").distinct }
  scope :with_student_role, -> { joins(:roles).where("roles.name = ?", "student").distinct }
  scope :admin, -> { joins(:roles).where("roles.name = ?", "admin").distinct.first }
  scope :with_external_auth, -> { where.not(encrypted_access_token: nil) & where.not(encrypted_refresh_token: nil) }
  scope :tutors_with_external_auth, -> { with_tutor_role.with_external_auth }
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

  def credit_status(invoice)
    invoice.engagement.academic_type.casecmp("academic") == 0 ? academic_credit : test_prep_credit
  end

  def is_student?
    client_info&.tutoring_for == 0
  end

  def is_tutor?
    has_role?("tutor")
  end
end
