FactoryBot.define do
  factory :student_user, class: User do
    name             { "Student" }
    phone_number     { "(510)555-5555" }
    sequence(:email) { |n| "student#{n}@example.com" }
    password         { "password" }
    roles            { Role.where(name: 'student') }
    access_state     { "enabled" }
    client           { FactoryBot.create(:client_user) }

    after(:create) do |user, _|
      user.create_student_account(client_account: user.client.client_account, name: user.name)
    end
  end
end
