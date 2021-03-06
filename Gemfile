source "https://rubygems.org"

ruby "2.6.3"

gem "autoprefixer-rails"
gem "sidekiq"
gem "jquery-rails"
gem "chosen-rails"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "puma"
# gem "rack-canonical-host" Temporarily disable until payments are figured out
gem "rails", "~> 5.1.2"
gem "recipient_interceptor"
gem "sass-rails", "~> 5.0"
gem "simple_form"
gem "sprockets", ">= 3.0.0"
gem "title"
gem "uglifier"
gem "bootstrap-sass", "~> 3.3.6"

# Payments
gem "stripe"
gem "oauth2"

# Feature flagging
gem "flipper"
gem "flipper-active_record"
gem "flipper-ui"

gem "bugsnag"
gem "clearance"

#gem "dwolla_v2", "~> 2.0"
gem "newrelic_rpm"
gem "omniauth"
gem "omniauth-oauth2"
gem "attr_encrypted", "~> 3.0.0"
gem "responders"
gem "state_machines"
gem "state_machines-activerecord"
gem "activemodel-serializers-xml"
gem "cancancan", "~> 1.16"
gem "money-rails", "~> 1"
gem "clockwork", "~> 2.0"
# gem "webpacker", "~> 3.5"
gem "slack-notifier"
gem "opentok", "~> 3.0.0"
gem "phonelib"
gem "carrierwave"
gem "mini_magick"
gem "ckeditor"
gem "fog-aws"
gem "geocoder"
gem 'will_paginate', '~> 3.1.0'
gem "sitemap_generator"
# gem "intercom-rails" # Not currently using Intercom. Uncomment the intercom initializer to re-enable

group :development do
  gem "listen"
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console"
  gem "letter_opener"
end

group :development, :test do
  gem "awesome_print"
  gem "bullet"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rb-readline"
end

group :development, :staging do
  gem "rack-mini-profiler", require: false
end

group :test do
  gem "chromedriver-helper"
  gem "capybara-selenium"
  gem "codecov", require: false
  gem "database_cleaner"
  gem "formulaic"
  gem "launchy"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
  gem "fake_stripe"
  gem "sinatra", "~> 2.0.0.rc2", require: false
  gem "vcr"
  gem "rspec-rails", "~> 3.5.0.beta4"
  gem "rspec_junit_formatter"
  gem "m"
end

group :staging, :production do
  gem "rack-timeout"
  gem "rails_stdout_logging"
end
