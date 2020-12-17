require 'spec_helper'

describe 'Service choices', js: true do
  # TODO: Make the service choice using the change service choice link when implemented
  before do
    TradeTariffFrontend::ServiceChooser.service_choice = choice
    VCR.use_cassette('geographical_areas#countries') do
      VCR.use_cassette('commodities#show_0201300020') do
        visit commodity_path('0201300020')
      end
    end
  end

  after do
    TradeTariffFrontend::ServiceChooser.service_choice = nil
  end

  context 'when using the default service as the current service backend' do
    let(:choice) { nil }

    it 'displays the correct tariff heading' do
      expect(page).to have_link('The Online Trade Tariff', href: '/sections')
    end
  end

  context 'when using uk as the current service backend' do
    let(:choice) { 'uk' }

    it 'displays the correct tariff heading' do
      expect(page).to have_link('The Online Trade Tariff', href: '/uk/sections')
    end
  end

  # TODO: Remove me when old uk service is removed
  context 'when using uk-old as the current service backend' do
    let(:choice) { 'uk-old' }

    it 'displays the correct tariff heading' do
      expect(page).to have_link('The Online Trade Tariff', href: '/sections')
    end
  end

  context 'when using xi as the current service backend' do
    let(:choice) { 'xi' }

    it 'displays the correct tariff heading' do
      expect(page).to have_link('The Northern Ireland (EU) Tariff for the XI', href: '/xi/sections')
    end
  end
end
