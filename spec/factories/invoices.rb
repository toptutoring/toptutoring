FactoryBot.define do
  factory :invoice do
    submitter    { FactoryBot.create(:tutor_user) }
    client       { FactoryBot.create(:client_user) }
    engagement   { FactoryBot.create(:engagement, tutor_account: submitter.tutor_account) }
    hours        { 2 }
    hourly_rate  { engagement.academic? ? client.online_academic_rate : client.online_test_prep_rate }
    amount       { hourly_rate * hours }
    online true
    submitter_type    { "by_tutor" }
    submitter_pay    { if submitter_type == "by_tutor"
                         account = submitter.tutor_account
                         rate = online ? account.online_rate : account.in_person_rate
                         rate * hours
                       else
                         submitter.contractor_account.hourly_rate * hours
                       end }
    description  { "This is an invoice" }
    subject      { "Subject" }
    status       { "pending" }
    session_rating { 4 }
  end
end
