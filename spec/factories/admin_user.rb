FactoryGirl.define do
  factory :admin_user, class: User do
    name              { "Admin" }
    email             { "admin@example.com" }
    password          { "password" }
    roles             { "admin" }
    token_expires_at  { 1524332549 }
  end
end
