FactoryGirl.define do
  factory :invoice do
    tutor        { FactoryGirl.create(:tutor_user) }
    client       { FactoryGirl.create(:client_user) }
    engagement   { FactoryGirl.create(:engagement, tutor: tutor, client: client) }
    hours        { 2 }
    hourly_rate  { engagement.academic_type == 'Academic' ? client.academic_rate : client.test_prep_rate }
    amount       { hourly_rate * hours }
    tutor_pay    { tutor.contract.hourly_rate * hours }
    description  { 'This is an invoice' }
    subject      { 'Subject' }
    status       { 'pending' }
  end
end
