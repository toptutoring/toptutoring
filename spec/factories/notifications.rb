FactoryBot.define do
  factory :notification do
    message_type "notice"
    title "A Notfiication"
    message "You received a notification"
    user { FactoryBot.create(:client_user) }
  end
end
