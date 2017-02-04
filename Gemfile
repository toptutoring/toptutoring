source "https://rubygems.org"

ruby "2.3.1"

gem "autoprefixer-rails"
gem "sidekiq"
gem "honeybadger"
gem "jquery-rails"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "puma"
# gem "rack-canonical-host" Temporarily disable until payments are figured out
gem "rails", "~> 5.0.0"
gem "recipient_interceptor"
gem "sass-rails", "~> 5.0"
gem "simple_form"
gem "skylight"
gem "sprockets", ">= 3.0.0"
gem "title"
gem "uglifier"
gem 'bootstrap-sass', '~> 3.3.6'

gem "bugsnag"
gem "clearance"
gem 'stripe', '~> 1.56'
gem "dwolla_v2", "~> 1.0"
gem "newrelic_rpm"
gem "omniauth"
gem "omniauth-oauth2"
gem "attr_encrypted", "~> 3.0.0"
gem "responders"
gem 'rack-cors', '~> 0.4.0', :require => 'rack/cors'
gem 'state_machines'
gem 'state_machines-activerecord'
gem 'activemodel-serializers-xml'
gem "sendgrid", "~> 1.2", ">= 1.2.4"
gem "sendgrid-ruby"

group :development do
  gem "listen"
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "bullet"
  gem "bundler-audit", ">= 0.5.0", require: false
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rb-readline"
  gem "rspec-rails", "~> 3.5.0.beta4"
  gem "vcr"
end

group :development, :staging do
  gem "rack-mini-profiler", require: false
end

group :test do
  gem "capybara-webkit"
  gem "database_cleaner"
  gem "formulaic"
  gem "launchy"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rack-timeout"
  gem "rails_stdout_logging"
end
