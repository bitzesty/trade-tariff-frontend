require 'spec_helper'

describe ExchangeRatesController, 'GET to #index', type: :controller do
  render_views

  around(:each) do |example|
    VCR.use_cassette('exchange_rates#index') do
      example.run
    end
  end

  before {
    get :index
  }

  let(:latest_rate) { MonetaryExchangeRate.all.last }

  it 'renders monetary exchange rates' do
    expect(response.body).to include latest_rate.exchange_rate
  end
end
