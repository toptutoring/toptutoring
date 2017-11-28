FactoryGirl.define do
  factory :client_account do
    user { FactoryGirl.create(:client_user) }
  end
end
