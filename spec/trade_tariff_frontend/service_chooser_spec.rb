require 'spec_helper'

describe TradeTariffFrontend::ServiceChooser do
  describe '.service_choices' do
    it 'returns a Hash of url options for the services' do
      expect(described_class.service_choices).to eq(
        "uk" => "http://localhost:3018",
        "uk-old" => "http://localhost:3018",
        "xi" => "http://localhost:3019"
      )
    end
  end

  describe '.service_choice=' do
    it 'assigns the service choice to the current Thread' do
      expect { described_class.service_choice = 'xi' }
        .to change { Thread.current[:service_choice] }
        .from(nil)
        .to('xi')

      # Don't pollute other tests with the service choice value
      described_class.service_choice = nil
    end
  end

  describe '.api_host' do
    around do |example|
      Thread.current[:service_choice] = choice
      example.run
      Thread.current[:service_choice] = nil
    end

    context 'when the service choice does not have a corresponding url' do
      let(:choice) { 'foo' }

      it 'returns the default service choice url' do
        expect(described_class.api_host).to eq('http://localhost:3018')
      end
    end

    context 'when the service choice has a corresponding url' do
      let(:choice) { 'xi' }

      it 'returns the service choice url' do
        expect(described_class.api_host).to eq('http://localhost:3019')
      end
    end
  end

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

    context 'when the service choice is xi' do
      let(:choice) { 'xi' }

      it 'caches under the service default key prefix' do
        described_class.cache_with_service_choice(cache_key, options) {}

        expect(Rails.cache).to have_received(:fetch).with('xi.foo', options)
      end
    end
  end
end
