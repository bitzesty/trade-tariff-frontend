require 'spec_helper'

describe 'Service choices', js: true do
  # TODO: Make the service choice using the change service choice link when implemented
  around do |example|
    TradeTariffFrontend::ServiceChooser.service_choice = choice
    example.call
    TradeTariffFrontend::ServiceChooser.service_choice = nil
  end

  let(:capybara_host) { Capybara.current_session.server.base_url }

  context 'when using the default service as the current service backend' do
    let(:choice) { nil }

    it 'displays the correct tariff heading' do
      VCR.use_cassette('sections#index', record: :new_episodes) do
        visit sections_path

        expect(page).to have_link('The Online Trade Tariff', href: '/sections')
      end
    end
  end

  context 'when using uk as the current service backend' do
    let(:choice) { 'uk' }

    it 'displays the correct tariff heading' do
      VCR.use_cassette('sections#index', record: :new_episodes) do
        visit sections_path

        expect(page).to have_link('The Online Trade Tariff', href: '/uk/sections')
      end
    end
  end

  # TODO: Remove me when old uk service is removed
  context 'when using uk-old as the current service backend' do
    let(:choice) { 'uk-old' }

    it 'displays the correct tariff heading' do
      VCR.use_cassette('sections#index', record: :new_episodes) do
        visit sections_path

        expect(page).to have_link('The Online Trade Tariff', href: '/sections')
      end
    end
  end

  context 'when using xi as the current service backend' do
    let(:choice) { 'xi' }

    it 'displays the correct tariff heading' do
      VCR.use_cassette('sections#index', record: :new_episodes) do
        visit sections_path

        expect(page).to have_link('The Northern Ireland (EU) Tariff for the XI', href: '/xi/sections')
      end
    end
  end
end
