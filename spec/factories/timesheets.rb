FactoryGirl.define do
  factory :timesheet do
    description   { "MyText" }
    date          { "2017-06-26" }
    status        { "MyString" }
    user          { FactoryGirl.create(:tutor_user) }
    minutes       { 60 }
  end
end
