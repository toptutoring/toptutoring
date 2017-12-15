FactoryGirl.define do
  factory :client_user, class: User do
    name          { "Client" }
    phone_number  { "555-5555" }
    sequence(:email) { |n| "client_#{n}@example.com" }
    password      { "password" }
    roles         { Role.where(name: 'client') }
    access_state  { "enabled" }
    customer_id   { "xxx" }
    academic_rate     { 20 }
    test_prep_rate    { 20 }
    academic_credit   { 20 }
    test_prep_credit  { 20 }
    signup   { FactoryGirl.create(:signup) }

    trait :as_student do
      signup { FactoryGirl.create(:signup, :as_student) }
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
