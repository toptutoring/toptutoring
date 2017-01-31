FactoryGirl.define do
  factory :admin_user, class: User do
    name     { "Admin" }
    email    { "admin@test.com" }
    password { "password" }
    admin    { true }
  end
end
