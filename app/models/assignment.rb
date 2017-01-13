class Assignment < ActiveRecord::Base
  # Associations
  belongs_to :student, class_name: "User", foreign_key: "student_id"
  belongs_to :tutor, class_name: "User", foreign_key: "tutor_id"

  #### Scopes ####

  scope :pending, -> { where(state: :pending).order('created_at DESC') }

  #### State Machine ####

  state_machine :state, :initial => :pending do
    event :enable do
      transition :pending => :active
    end

    event :disable do
      transition :active => :inactive
    end
  end
end
