class TestScore < ApplicationRecord
  belongs_to :tutor_account
  belongs_to :subject
end
