require 'spec_helper'

describe ServiceHelper, type: :helper do
  before do
    allow(TradeTariffFrontend::ServiceChooser).to receive(:service_choice).and_return(choice)
  end

  describe ".trade_tariff_heading" do
    context 'when the selected service choice is uk-old' do
      let(:choice) { 'uk-old' }

      it 'returns The Online Trade Tariff' do
        expect(trade_tariff_heading).to eq('The Online Trade Tariff')
      end
    end

    context 'when the selected service choice is uk' do
      let(:choice) { 'uk' }

      it 'returns The Online Trade Tariff' do
        expect(trade_tariff_heading).to eq('The Online Trade Tariff')
      end
    end

    context 'when the selected service choice is xi' do
      let(:choice) { 'xi' }

      it 'returns The Northern Ireland (EU) Tariff for the XI' do
        expect(trade_tariff_heading).to eq('The Northern Ireland (EU) Tariff for the XI')
      end
    end
  end

  describe ".switch_service_link" do
    let(:request) { double('request', filtered_path: path) }

    before do
      allow(helper).to receive(:request).and_return(request)
    end

    context 'when the selected service choice is uk-old' do
      let(:path) { '/sections/1' }
      let(:choice) { 'uk-old' }

      it 'returns the link to the XI service' do
        expect(switch_service_link).to eq(link_to('The Northern Ireland (EU) Tariff for the XI', '/xi/sections/1'))
      end
    end

    context 'when the selected service choice is uk' do
      let(:path) { '/uk/sections/1' }
      let(:choice) { 'uk' }

      it 'returns the link to the XI service' do
        expect(switch_service_link).to eq(link_to('The Northern Ireland (EU) Tariff for the XI', '/xi/sections/1'))
      end
    end

    context 'when the selected service choice is xi' do
      let(:path) { '/xi/sections/1' }
      let(:choice) { 'xi' }

      it 'returns the link to the current UK service' do
        expect(switch_service_link).to eq(link_to('The Online Trade Tariff', '/sections/1'))
      end
    end
  end
end
