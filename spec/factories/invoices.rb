FactoryGirl.define do
  factory :invoice do
    tutor         { FactoryGirl.create(:tutor_user) }
    engagement    { FactoryGirl.create(:engagement, tutor: tutor) }
    hours         { 2 }
    amount        { 40 }
  end
end
