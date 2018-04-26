FactoryBot.define do
  factory :dwolla_event do
    event_id "dwolla_event_id"
    topic "transfer_completed"
    resource_url "a_resource_url"
  end
end
