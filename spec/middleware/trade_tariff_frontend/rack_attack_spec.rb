require 'spec_helper'

describe Rack::Attack, vcr: { cassette_name: "sections#index" } do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  context 'when app is not locked' do
    before { ENV['CDS_LOCKED_IP'] = nil }
    before { ENV['CDS_IP_WHITELIST'] = nil }
    before { ENV['CDS_LOCKED_AUTH'] = nil }
    before { ENV['CDS_USER'] = nil }
    before { ENV['CDS_PASSWORD'] = nil }

    before { get '/sections' }

    it { expect(last_response.status).to eq(200) }
  end

  context 'when app is locked' do
    before { ENV['CDS_LOCKED_IP'] = 'true' }
    before { ENV['CDS_IP_WHITELIST'] = '127.0.0.1' }
    before { ENV['CDS_LOCKED_AUTH'] = nil }
    before { ENV['CDS_USER'] = nil }
    before { ENV['CDS_PASSWORD'] = nil }

    context 'and ip is not listed' do
      before { get '/sections', {}, { 'REMOTE_ADDR' => '1.2.3.4' } }

      it { expect(last_response.status).to eq(403) }
    end

    context 'and ip is listed' do
      before { get '/sections', {}, { 'REMOTE_ADDR' => '127.0.0.1' } }

      it { expect(last_response.status).to eq(200) }
    end

    after { ENV['CDS_LOCKED_IP'] = nil }
    after { ENV['CDS_IP_WHITELIST'] = nil }
    after { ENV['CDS_LOCKED_AUTH'] = nil }
    after { ENV['CDS_USER'] = nil }
    after { ENV['CDS_PASSWORD'] = nil }
  end

  context 'when app has no CDN lock' do
    before { ENV['CDN_SECRET_KEY'] = nil }

    before { get '/sections' }

    it { expect(last_response.status).to eq(200) }
  end

  context 'when app has CDN lock' do
    before { ENV['CDN_SECRET_KEY'] = 'CDN_SECRET_KEY' }

    context 'request has no secret key header value' do
      before { get '/sections' }

      it { expect(last_response.status).to eq(403) }
    end

    context 'request has wrong secret key header value' do
      before { get '/sections', {}, { 'CDN_SECRET' => 'CDN_SECRET' } }

      it { expect(last_response.status).to eq(403) }
    end

    context 'request has correct secret key header value' do
      before { get '/sections', {}, { 'CDN_SECRET' => 'CDN_SECRET_KEY' } }

      it { expect(last_response.status).to eq(200) }
    end

    after { ENV['CDN_SECRET_KEY'] = nil }
  end
end
