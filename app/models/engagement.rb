class Engagement < ActiveRecord::Base
  # Associations
  belongs_to :student, class_name: "User", foreign_key: "student_id"
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"
  belongs_to :subject

  has_many :invoices
  has_many :availabilities
  has_many :suggestions

  #### Scopes ####

  scope :pending, -> { where(state: :pending).order('created_at DESC') }
  scope :active, -> { where(state: :active) }

  #### Validations ####
  validates_presence_of :student_name
  validates_presence_of :client

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

  def updated?
    tutor
  end
end
