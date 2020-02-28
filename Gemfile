source "https://rubygems.org"
ruby "~> 2.6.5"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "~> 2.6.2"

gem "rails", "6.0.2.1"

gem "yajl-ruby", "~> 1.3.1", require: "yajl"
gem "multi_json", "~> 1.11"
gem "faraday"
gem "faraday_middleware"
gem "addressable", "~> 2.3"
gem "hashie", "~> 3.4"

# Assets
gem "coffee-rails", "~> 4.2.2", ">= 4.1.0"
gem "jquery-rails", "~> 4.2.2"
gem "jquery-migrate-rails"
gem "sass-rails"
gem "uglifier", "~> 2.7"
gem "responders", "~> 3.0.0"
gem "bootsnap", require: false
gem "kaminari", "~> 1.0"

# gov UK
gem "govspeak", '~> 6.5.2'
gem "i18n", '~> 0.7'
gem "govuk_template", ">= 0.23.0"
gem "govuk_frontend_toolkit", "8.2.0"
gem "govuk_elements_rails", ">= 3.1.3"
gem "plek", "~> 1.11"

gem "connection_pool", "~> 2.2"

gem "nokogiri", ">= 1.10.4"

# Logging
gem "logstash-event"
gem "lograge"

# Web Server
gem 'puma', '~> 3.12'
gem 'rack-cors'
gem 'rack-attack'
gem "scout_apm"

# Redis
gem "redis-rails"

# AWS
gem "aws-sdk", "~> 2"
gem "aws-sdk-rails", ">= 1.0.1"

group :development do
  gem "web-console", ">= 3.3.0"
  gem "letter_opener"
  gem "govuk-lint"
end

group :development, :test do
  gem "pry-rails"
  gem "dotenv-rails"
end

group :test do
  gem "rails-controller-testing"
  gem "webmock", "~> 3.5.0"
  gem "factory_girl_rails", "~> 4.8.0"
  gem "forgery"
  gem "shoulda-matchers", "~> 3.1.1"
  gem "vcr", "~> 3.0.3"
  gem "simplecov", "~> 0.15.0", require: false
  gem "rspec-rails", "~> 3.5.2"
  gem "capybara", "~> 2.18.0"
  gem "poltergeist", "~> 1.14.0"
  gem "timecop", "~> 0.8.1"
  gem "rspec_junit_formatter"
  gem 'rack-test'
end

group :production do
  gem "rails_12factor"
  gem "sentry-raven"
end
