FactoryBot.define do
  factory :blog_post do
    title        { "My Title" }
    content      { "MyText" }
    publish_date { "2017-12-30" }
    draft    { true }
    user         { User.admin }
  end
end
