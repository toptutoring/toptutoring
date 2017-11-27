FactoryGirl.define do
  factory :student_account do
    user { FactoryGirl.create(:user, :as_student) }
    client { FactoryGirl.create(:client_user) }
    name { user ? user.name : client.name }
  end
end
