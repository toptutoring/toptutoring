FactoryGirl.define do
  factory :student_account do
    client_account { FactoryGirl.create(:client_account) }
    user { FactoryGirl.create(:student_user, client: client_account.user) }
    name { user ? user.name : client.name }
  end
end
