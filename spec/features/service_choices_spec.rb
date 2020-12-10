require "spec_helper"

describe "Service choices", js: true do
  # TODO: Make the service choice using the change service choice link when implemented
  around do |example|
    TradeTariffFrontend::ServiceChooser.service_choice = choice
    example.call
    TradeTariffFrontend::ServiceChooser.service_choice = nil
  end

  let(:capybara_host) { Capybara.current_session.server.base_url }

  context 'when using the default service as the current service backend' do
    let(:choice) { nil }

    it "renders the search container properly" do
      VCR.use_cassette("sections#index_uk", record: :new_episodes) do
        visit sections_path

        expect(page).to have_link("UK Live animals; animal products", href: "/sections/1")
        expect(page).to have_link("Search", href: "/sections")
        expect(page).to have_link('Additional code', href: "/additional_code_search")
        expect(page).to have_link('Certificate', href: "/certificate_search")
        expect(page).to have_link('Footnotes', href: "/footnote_search")
        expect(page).to have_link('Quotas', href: "/quota_search")
        expect(page).to have_link('CAS', href: "/chemical_search")
        expect(page).to have_link('A-Z', href: "/a-z-index/a")
        expect(page).to have_link('Exchange rates', href: "/exchange_rates")
        expect(page).to have_link('Forum', href: "https://forum.trade-tariff.service.gov.uk/")
      end
    end
  end

  context 'when using uk as the current service backend' do
    let(:choice) { 'uk' }

    it "renders the search container properly" do
      VCR.use_cassette("sections#index_uk", record: :new_episodes) do
        visit sections_path

        expect(page).to have_link("UK Live animals; animal products", href: "/sections/1")
        expect(page).to have_link("Search", href: "/sections")
        expect(page).to have_link('Additional code', href: "/additional_code_search")
        expect(page).to have_link('Certificate', href: "/certificate_search")
        expect(page).to have_link('Footnotes', href: "/footnote_search")
        expect(page).to have_link('Quotas', href: "/quota_search")
        expect(page).to have_link('CAS', href: "/chemical_search")
        expect(page).to have_link('A-Z', href: "/a-z-index/a")
        expect(page).to have_link('Exchange rates', href: "/exchange_rates")
        expect(page).to have_link('Forum', href: "https://forum.trade-tariff.service.gov.uk/")
      end
    end
  end


  context 'when using xi as the current service backend' do
    let(:choice) { 'xi' }

    it "renders the search container properly" do
      VCR.use_cassette("sections#index_xi", record: :new_episodes) do
        visit sections_path

        expect(page).to have_link("XI Live animals; animal products", href: "/xi/sections/1")
        expect(page).to have_link("Search", href: "/xi/sections")
        expect(page).to have_link('Additional code', href: "/xi/additional_code_search")
        expect(page).to have_link('Certificate', href: "/xi/certificate_search")
        expect(page).to have_link('Footnotes', href: "/xi/footnote_search")
        expect(page).to have_link('Quotas', href: "/xi/quota_search")
        expect(page).to have_link('CAS', href: "/xi/chemical_search")
        expect(page).to have_link('A-Z', href: "/xi/a-z-index/a")
        expect(page).to have_link('Exchange rates', href: "/xi/exchange_rates")
        expect(page).to have_link('Forum', href: "https://forum.trade-tariff.service.gov.uk/")
      end
    end
  end
end
