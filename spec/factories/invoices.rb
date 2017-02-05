FactoryGirl.define do
  factory :invoice do
    tutor         { FactoryGirl.create(:tutor_user) }
    assignment    { FactoryGirl.create(:assignment, tutor: tutor) }
    hours         { 2 }
    hourly_rate   { 20 }
    amount        { 40 }
  end
end