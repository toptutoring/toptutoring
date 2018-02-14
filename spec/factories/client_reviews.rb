FactoryBot.define do
  factory :client_review do
    client_account nil
    review "Top Tutoring is the best!"
    stars 5
    permission_to_publish false
  end
end
