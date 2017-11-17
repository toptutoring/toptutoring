FactoryGirl.define do
  factory :admin_user, class: User do
    name              { "Admin" }
    sequence(:email) { |n| "admin#{n}@example.com" }
    password          { "password" }
    roles             { Role.where(name: 'admin') }
    token_expires_at  { 1524332549 }
  end
end
