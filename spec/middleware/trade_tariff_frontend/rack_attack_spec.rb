require 'spec_helper'

describe Rack::Attack, vcr: { cassette_name: "sections#index" } do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  context 'when app is not locked' do
    before { ENV['CDS_LOCKED'] = nil }
    before { ENV['CDS_IP_WHITELIST'] = nil }
    before { ENV['CDS_USER'] = nil }
    before { ENV['CDS_PASSWORD'] = nil }
    before { get 'trade-tariff/sections' }

    it { expect(last_response.status).to eq(200) }
  end

  context 'when app is locked' do
    before { ENV['CDS_LOCKED'] = 'true' }
    before { ENV['CDS_IP_WHITELIST'] = '127.0.0.1' }
    before { ENV['CDS_USER'] = nil }
    before { ENV['CDS_PASSWORD'] = nil }

    context 'and ip is not listed' do
      before { get 'trade-tariff/sections', {}, { 'REMOTE_ADDR' => '1.2.3.4' } }

      it { expect(last_response.status).to eq(403) }
    end

    context 'and ip is listed' do
      before { get 'trade-tariff/sections', {}, { 'REMOTE_ADDR' => '127.0.0.1' } }

      it { expect(last_response.status).to eq(200) }
    end

    after { ENV['CDS_LOCKED'] = nil }
    after { ENV['CDS_IP_WHITELIST'] = nil }
    after { ENV['CDS_USER'] = nil }
    after { ENV['CDS_PASSWORD'] = nil }
  end

end