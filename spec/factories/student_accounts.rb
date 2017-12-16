FactoryBot.define do
  factory :student_account do
    client_account { FactoryBot.create(:client_user).create_client_account }
    user { FactoryBot.create(:student_user, client: client_account.user) }
    name { user ? user.name : client.name }
  end
end
