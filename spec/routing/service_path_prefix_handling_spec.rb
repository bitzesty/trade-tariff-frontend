require 'spec_helper'

describe RoutingFilter::ServicePathPrefixHandler, type: :routing do
  before do
    allow(TradeTariffFrontend::ServiceChooser).to receive(:service_choice=)
    allow(TradeTariffFrontend::ServiceChooser).to receive(:service_choices).and_return(service_choices)
    allow(TradeTariffFrontend::ServiceChooser).to receive(:service_default).and_return(service_default)
  end

  let(:service_choices) do
    {
      'xi' => 'http://localhost:3000',
      'uk' => 'http://localhost:3001',
    }
  end

  let(:service_default){ 'uk' }
  let(:path) { "#{prefix}/commodities/0101300000" }

  describe 'matching routes' do
    context 'when the service choice prefix is xi' do
      let(:prefix) { "/xi" }

      it 'sets the request params service choice to the xi backend' do
        expect(get: path).to route_to(
          controller: "commodities",
          action: "show",
          id: "0101300000",
          service_api_choice: "xi"
        )
        expect(TradeTariffFrontend::ServiceChooser).to have_received(:service_choice=).with("xi")
      end
    end

    context 'when the service choice prefix is not present' do
      let(:prefix) { nil }

      it 'does not specify the service backend' do
        expect(get: path).to route_to(
          controller: "commodities",
          action: "show",
          id: "0101300000",
        )
        expect(TradeTariffFrontend::ServiceChooser).not_to have_received(:service_choice=)
      end
    end

    context 'when the service choice prefix is the same as the default' do
      let(:prefix) { '/uk' }

      it 'does not set the request params service choice' do
        expect(get: path).to route_to(
          controller: "commodities",
          action: "show",
          id: "0101300000",
        )
        expect(TradeTariffFrontend::ServiceChooser).not_to have_received(:service_choice=)
      end
    end

    context 'when the service choice prefix is set to an unsupported service choice' do
      let(:prefix) { "/foo" }

      it 'routes to a not_found action in the errors controller' do
        expect(get: path).to route_to(
          controller: "errors",
          action: "not_found",
          path: "foo/commodities/0101300000",
        )

        expect(TradeTariffFrontend::ServiceChooser).not_to have_received(:service_choice=)
      end
    end
  end

  describe 'path generation' do
    before do
      allow(TradeTariffFrontend::ServiceChooser).to receive(:service_choice).and_return(choice)
      allow(TradeTariffFrontend::ServiceChooser).to receive(:service_default).and_return(service_default)
    end

    let(:commodity_id) { '0101210000' }
    let(:service_default) { 'uk' }

    context 'when the service choice is not the default' do
      let(:choice) { 'xi' }

      it 'prepends the choice to the url' do
        result = commodity_url(
          id: commodity_id,
          currency: 'EUR'
        )

        expect(result).to eq("http://test.host/xi/commodities/0101210000?currency=EUR")
      end

      it 'prepends the choice to the path' do
        result = commodity_path(
          id: commodity_id,
          currency: 'EUR'
        )

        expect(result).to eq("/xi/commodities/0101210000?currency=EUR")
      end
    end

    context 'when the service choice is the default' do
      let(:choice) { 'uk' }

      it 'does not prepend the choice to the url' do
        result = commodity_path(
          id: commodity_id,
          currency: 'EUR'
        )

        expect(result).to eq("/commodities/0101210000?currency=EUR")
      end

      it 'does not prepend the choice to the path' do
        result = commodity_path(
          id: commodity_id,
          currency: 'EUR'
        )

        expect(result).to eq("/commodities/0101210000?currency=EUR")
      end
    end
  end
end
