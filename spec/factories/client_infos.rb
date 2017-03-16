FactoryGirl.define do
  factory :client_info do
    subject       { "Math" }
    tutoring_for  { 1 }
  end
end
