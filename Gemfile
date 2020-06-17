source "https://rubygems.org"
ruby "~> 2.7.1"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", ">= 6.0.3.1"

gem "yajl-ruby", "~> 1.3.1", require: "yajl"
gem "multi_json", "~> 1.11"
gem "faraday"
gem "faraday_middleware", "~> 1"
gem "addressable", "~> 2.3"
gem "hashie", "~> 3.4"

# Assets
gem "coffee-rails", "~> 5", ">= 5.0.0"
gem "jquery-rails", "~> 4.4.0"
gem "jquery-migrate-rails"
gem "sass-rails", ">= 6.0.0"
gem "uglifier", "~> 2.7"
gem "responders", "~> 3.0.0"
gem "bootsnap", require: false
gem "kaminari", "~> 1.0"

# gov UK
gem "govspeak", "~> 6.5.2"
gem "i18n", '~> 0.7'
gem "govuk_template", ">= 0.25.0"
gem "govuk_frontend_toolkit", "8.2.0"
gem "govuk_elements_rails", ">= 3.1.3"
gem "plek", "~> 1.11"

gem "connection_pool", "~> 2.2"

gem "nokogiri", ">= 1.10.9"

# Logging
gem "logstash-event"
gem "lograge", ">= 0.11.2"

# Web Server
gem 'puma', '~> 3.12.6'
gem 'rack-cors', '>= 1.1.0'
gem 'rack-attack', '>= 5.4.2'
gem "scout_apm"

# Redis
gem "redis-rails", ">= 5.0.2"

# AWS
gem "aws-sdk", "~> 3"
gem "aws-sdk-rails", "~> 3", ">= 3.1.0"

group :development do
  gem "web-console", ">= 3.3.0"
  gem "letter_opener"
  gem "govuk-lint"
end

group :development, :test do
  gem "pry-rails"
  gem "dotenv-rails", ">= 2.7.5"
end

group :test do
  gem "rails-controller-testing", github: "rails/rails-controller-testing", branch: "master"
  gem "webmock", "~> 3.8.0"
  gem "factory_bot_rails", ">= 5.2.0"
  gem "forgery"
  gem "shoulda-matchers", "~> 4"
  gem "vcr", "~> 3.0.3"
  gem "simplecov", "~> 0.18", require: false
  gem "rspec-rails", "~> 4", ">= 4.0.1"
  gem "capybara", "~> 3", ">= 3.32.2"
  gem "selenium-webdriver"
  gem "timecop", "~> 0.9.1"
  gem "rspec_junit_formatter"
  gem 'rack-test', '>= 1.1.0'
end

group :production do
  gem "sentry-raven"
end
