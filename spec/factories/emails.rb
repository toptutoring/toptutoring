FactoryGirl.define do
  factory :email do
    subject { "2 hours of tutoring invoiced by Tutor" }
    body    { "Tutor has invoiced 2 hours of tutoring for Math." }
  end
end
