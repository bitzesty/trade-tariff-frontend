source "https://rubygems.org"
ruby "~> 2.7.1"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", ">= 6.0.3.4"

gem "yajl-ruby", "~> 1.3.1", require: "yajl"
gem "multi_json", "~> 1.11"
gem "faraday"
gem "faraday_middleware", "~> 1"
gem "addressable", "~> 2.3"
gem "hashie", "~> 3.4"
gem 'routing-filter', '~> 0.6.3'

# Assets
gem "responders", "~> 3.0.0"
gem "bootsnap", require: false
gem "kaminari", "~> 1.0"
gem "webpacker", "~> 5.2"

# gov UK
gem "govspeak", "~> 6.5.6"
gem "plek", "~> 1.11"

gem "connection_pool", "~> 2.2"

gem "nokogiri", ">= 1.10.10"

# Logging
gem "logstash-event"
gem "lograge"

# Web Server
gem "puma", "~> 5.0.4"
gem "rack-cors"
gem "rack-attack"
gem "scout_apm"

# Redis
gem "redis-rails"

# AWS
gem "aws-sdk", "~> 3"
gem "aws-sdk-rails", "~> 3"

group :development do
  gem "web-console", ">= 3.3.0"
  gem "letter_opener"
  gem "govuk-lint"
end

group :development, :test do
  gem 'pry'
  gem "dotenv-rails"
end

group :test do
  gem "rails-controller-testing", github: "rails/rails-controller-testing", branch: "master"
  gem "webmock", "~> 3.8.0"
  gem "factory_bot_rails"
  gem "forgery"
  gem "shoulda-matchers", "~> 4"
  gem "vcr", "~> 3.0.3"
  gem "simplecov", "~> 0.18", require: false
  gem "rspec-rails", "~> 4"
  gem "capybara", "~> 3"
  gem "selenium-webdriver"
  gem "timecop", "~> 0.9.1"
  gem "rspec_junit_formatter"
  gem "rack-test"
  gem 'webdrivers', "~> 4.4"
end

group :production do
  gem "sentry-raven"
end
