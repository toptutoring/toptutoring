ENV["RACK_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)

abort("DATABASE_URL environment variable is set") if ENV["DATABASE_URL"]

require "rspec/rails"
require "clearance/rspec"
require "selenium/webdriver"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }

module Features
  # Extend this module in spec/support/features/*.rb
  include Formulaic::Dsl
end

RSpec.configure do |config|
  config.include Features, type: :feature
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    load "#{Rails.root}/db/seeds.rb"
  end

  config.around(:each) do |spec|
    DatabaseCleaner.strategy = spec.metadata[:js] ? :truncation : :transaction

    DatabaseCleaner.cleaning do
      spec.run
    end

    load "#{Rails.root}/db/seeds.rb" if spec.metadata[:js]
    Capybara.reset_sessions!
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

ActiveRecord::Migration.maintain_test_schema!
