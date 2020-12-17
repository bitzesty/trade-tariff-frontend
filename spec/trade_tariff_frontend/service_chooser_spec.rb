require 'spec_helper'

describe TradeTariffFrontend::ServiceChooser do
  describe '.cache_with_service_choice' do
    let(:cache_key) { 'foo' } 
    let(:options) { {} } 

    before do
      described_class.service_choice = choice
      allow(Rails.cache).to receive(:fetch)
    end

    after do
      described_class.service_choice = nil
    end

    context 'when the service choice is nil' do
      let(:choice) { nil }

      it 'caches under the service default key prefix' do
        described_class.cache_with_service_choice(cache_key, options) {}

        expect(Rails.cache).to have_received(:fetch).with('uk-old.foo', options)

      end
    end

    context 'when the service choice is uk-old' do
      let(:choice) { 'uk-old' }

      it 'caches under the service default key prefix' do
        described_class.cache_with_service_choice(cache_key, options) {}

        expect(Rails.cache).to have_received(:fetch).with('uk-old.foo', options)

      end
    end

    context 'when the service choice is uk' do
      let(:choice) { 'uk' }

      it 'caches under the service default key prefix' do
        described_class.cache_with_service_choice(cache_key, options) {}

        expect(Rails.cache).to have_received(:fetch).with('uk.foo', options)

      end
    end

    context 'when the service choice is xi' do
      let(:choice) { 'xi' }

      it 'caches under the service default key prefix' do
        described_class.cache_with_service_choice(cache_key, options) {}

        expect(Rails.cache).to have_received(:fetch).with('xi.foo', options)

      end
    end
  end
end
