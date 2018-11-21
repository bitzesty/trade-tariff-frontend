require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join('spec', 'vcr')
  c.hook_into :webmock
  # c.debug_logger = $stdout
  c.default_cassette_options = { match_requests_on: [:path] }
  c.configure_rspec_metadata!
  c.ignore_request do |request|
    URI(request.uri).host.in?(%w(localhost 127.0.0.1)) && URI(request.uri).port != 3018
  end
end
