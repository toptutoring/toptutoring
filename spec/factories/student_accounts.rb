FactoryBot.define do
  factory :student_account do
    client_account { FactoryBot.create(:client_user).client_account }
    user { FactoryBot.create(:student_user, client: client_account.user) }
    name { user ? user.full_name : client.full_name }
  end
end
