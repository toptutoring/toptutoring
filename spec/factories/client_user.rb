FactoryBot.define do
  factory :client_user, class: User do
    name          { "Client" }
    phone_number  { "(510)555-5555" }
    sequence(:email) { |n| "client_#{n}@example.com" }
    password      { "password" }
    roles         { Role.where(name: 'client') }
    access_state  { "enabled" }
    customer_id   { "xxx" }
    online_academic_rate     { 20 }
    online_test_prep_rate    { 20 }
    online_academic_credit   { 20 }
    online_test_prep_credit  { 20 }
    in_person_academic_rate     { 30 }
    in_person_test_prep_rate    { 30 }
    in_person_academic_credit   { 30 }
    in_person_test_prep_credit  { 30 }
    signup   { FactoryBot.create(:signup) }

    trait :as_student do
      signup { FactoryBot.create(:signup, :as_student) }
    end

    trait :invalid_record do
      to_create { |instance| instance.save(validate: false) }
    end

    after(:create) do |user, _|
      user.create_client_account
      if user.signup.student
        user.client_account
            .student_accounts
            .create(user: user, name: user.name)
      end
    end
  end
end
