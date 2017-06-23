class Engagement < ActiveRecord::Base
  # Associations
  belongs_to :student, class_name: "User", foreign_key: "student_id"
  belongs_to :client, class_name: "User", foreign_key: "client_id"
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"

  has_many :invoices
  has_many :suggesions

  #### Scopes ####

  scope :pending, -> { where(state: :pending).order('created_at DESC') }
  scope :active, -> { where(state: :active) }

  #### Validations ####
  validates_presence_of :student_name
  validates_presence_of :client
  validates_presence_of :academic_type

  #### State Machine ####

  state_machine :state, :initial => :pending do
    event :enable do
      transition :pending => :active
    end

    event :disable do
      transition :active => :pending
    end
  end

  def updated?
    tutor
  end
end
