FactoryGirl.define do
  factory :tutor_user, class: User do
    name                { "Tutor" }
    sequence(:email) { |n| "tutor_#{n}@example.com" }
    password            { "password" }
    roles               { "tutor" }
    auth_uid            { "xxx-xxx" }
    access_token        { "ijvzSZLAbk78MtNTRZbb6nFTSyXFedwZ74zuwbXEs3p77K6FoG" }
    refresh_token       { "CYojEe4hMnVzLeXbWbPEPJy2WF7kNvuNvzN6EAdIY5zTXJsvYU" }
    contract            { FactoryGirl.create(:contract) }
    access_state        { "enabled" }
  end
end
