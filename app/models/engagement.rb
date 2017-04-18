class Engagement < ActiveRecord::Base
  # Associations
  belongs_to :student, class_name: "User", foreign_key: "student_id"
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"
  has_many :invoices

  #### Scopes ####

  scope :pending, -> { where(state: :pending).order('created_at DESC') }
  scope :active, -> { where(state: :active) }

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
    hourly_rate && tutor
  end
end
