class Engagement < ActiveRecord::Base
  # Associations
  belongs_to :student_account
  belongs_to :client_account
  belongs_to :tutor_account
  belongs_to :subject

  # Engagements with invoices should not be destroyed
  has_many :invoices
  has_many :availabilities, dependent: :destroy

  #### Scopes ####
  scope :pending, -> { where(state: :pending).order('created_at DESC') }
  scope :not_pending, -> { where.not(state: :pending).order('created_at DESC') }
  scope :active, -> { where(state: :active) }
  scope :processing, -> { where.not(state: :archived) }
  scope :archived, -> { where(state: :archived) }

  #### Validations ####
  validates_presence_of :subject
  validates_presence_of :student_account
  validates_presence_of :client_account

  #### State Machine ####
  state_machine :state, :initial => :pending do
    event :enable do
      transition :pending => :active, if: [:tutor_account, :rates_are_set?]
      transition :archived => :active, if: [:tutor_account, :rates_are_set?]
    end

    event :disable do
      transition :active => :archived
    end
  end

  delegate :academic?, :test_prep?, :academic_type, to: :subject

  def client
    @client ||= client_account.user
  end

  def updated?
    tutor_account
  end

  def student_name
    @student_name ||= student_account.name
  end

  def student
    @student ||= student_account.try(:user)
  end

  def tutor
    @tutor ||= tutor_account.try(:user)
  end

  def able_to_delete?
    invoices.none? && !active?
  end

  def rate_for?(tutoring_type)
    client.rate_set?("#{tutoring_type}_#{academic_type}")
  end

  def rates_are_set?
    rate_for?("online") || rate_for?("in_person")
  end

  def relevant_credits
    @relevant_credits ||= %w[online in_person].each_with_object([]) do |type, array|
      array << "#{type}_#{academic_type}_credit" if rate_for?(type)
    end
  end

  def low_balance?
    relevant_credits.any? do |credit_type|
      client.send(credit_type) <= 0
    end
  end

  def credits_remaining?
    relevant_credits.any? do |credit_type|
      client.send(credit_type) > 0
    end
  end
end
