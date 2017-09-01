FactoryGirl.define do
  factory :funding_source do
    funding_source_id { ENV.fetch("DWOLLA_DEV_FUNDING_SOURCE") }
  end
end
