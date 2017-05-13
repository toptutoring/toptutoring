class TutorProfile < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :subject
end
