class Engagement < ActiveRecord::Base
  # Associations
  belongs_to :student_account
  belongs_to :client_account
  belongs_to :tutor_account
  belongs_to :subject

  # Engagements with invoices should not be destroyed
  has_many :invoices
  has_many :availabilities, dependent: :destroy
  has_many :suggestions, dependent: :destroy

  #### Scopes ####
  scope :pending, -> { where(state: :pending).order('created_at DESC') }
  scope :active, -> { where(state: :active) }

  #### Validations ####
  validates_presence_of :subject
  validates_presence_of :student_account
  validates_presence_of :client_account

  #### State Machine ####
  state_machine :state, :initial => :pending do
    event :enable do
      transition :pending => :active
    end

    event :disable do
      transition :active => :pending
    end
  end

  delegate :academic?, :test_prep?, :academic_type, to: :subject

  def client
    client_account.user
  end

  def updated?
    tutor_account
  end

  def student_name
    student_account.name
  end

  def student
    student_account.try(:user)
  end

  def tutor
    tutor_account.try(:user)
  end
end
