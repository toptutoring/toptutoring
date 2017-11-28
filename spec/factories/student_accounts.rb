FactoryGirl.define do
  factory :student_account do
    user { FactoryGirl.create(:student_user) }
    client { FactoryGirl.create(:client_user) }
    name { user ? user.name : client.name }
  end
end
