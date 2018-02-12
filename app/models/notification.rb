class Notification < ApplicationRecord
  belongs_to :user
  scope :unread, -> { where(read: false) }

  enum message_type: { notice: "notice", invoice: "invoice", alert: "alert" }
end
