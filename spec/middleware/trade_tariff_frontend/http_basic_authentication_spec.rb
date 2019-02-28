require 'spec_helper'

describe '', vcr: { cassette_name: "sections#index" } do
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

    before { get 'trade-tariff/sections' }

    it { expect(last_response.status).to eq(200) }
  end

  context 'when app is locked' do
    let(:correct_user) { 'user' }
    let(:wrong_user) { 'user12' }
    let(:correct_password) { 'password' }
    let(:wrong_password) { 'password12' }

    before { ENV['CDS_LOCKED_IP'] = nil }
    before { ENV['CDS_IP_WHITELIST'] = nil }
    before { ENV['CDS_LOCKED_AUTH'] = 'true' }
    before { ENV['CDS_USER'] = correct_user }
    before { ENV['CDS_PASSWORD'] = correct_password }

    context 'and credentials is wrong' do
      before { get 'trade-tariff/sections', {}, { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(wrong_user,wrong_password) } }

      it { expect(last_response.status).to eq(401) }
    end

    context 'and credentials is correct' do
      before { get 'trade-tariff/sections', {}, { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(correct_user,correct_password) } }

      it {
        expect(last_response.status).to eq(200)
      }
    end

    after { ENV['CDS_LOCKED_IP'] = nil }
    after { ENV['CDS_IP_WHITELIST'] = nil }
    after { ENV['CDS_LOCKED_AUTH'] = nil }
    after { ENV['CDS_USER'] = nil }
    after { ENV['CDS_PASSWORD'] = nil }
  end

end