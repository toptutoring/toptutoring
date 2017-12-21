FactoryBot.define do
  factory :invoice do
    submitter    { FactoryBot.create(:tutor_user) }
    client       { FactoryBot.create(:client_user) }
    engagement   { FactoryBot.create(:engagement, tutor_account: submitter.tutor_account) }
    hours        { 2 }
    hourly_rate  { engagement.academic? ? client.academic_rate : client.test_prep_rate }
    amount       { hourly_rate * hours }
    submitter_type    { "by_tutor" }
    submitter_pay    { if submitter_type == "by_tutor"
                         submitter.tutor_account.contract.hourly_rate * hours
                       else
                         submitter.contractor_account.contract.hourly_rate * hours
                       end }
    description  { "This is an invoice" }
    subject      { "Subject" }
    status       { "pending" }
    end
  end
