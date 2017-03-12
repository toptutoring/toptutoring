class ClientInfo < ActiveRecord::Base
  MYSELF = 0
  SOMEONE_ELSE = 1
  TUTORING_FOR = [MYSELF, SOMEONE_ELSE]

  belongs_to :user
end
