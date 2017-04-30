FactoryGirl.define do
  factory :tutor_user, class: User do
    name                { "Tutor" }
    email               { "tutor@test.com" }
    password            { "password" }
    roles               { "tutor" }
    auth_uid            { "xxx-xxx" }
    access_token        { "xxx-xxx" }
    refresh_token       { "xxx-xxx" }
    contract            { FactoryGirl.create(:contract) }
    access_state        { "enabled" }
  end
end
