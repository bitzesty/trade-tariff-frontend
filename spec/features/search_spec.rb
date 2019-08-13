require "spec_helper"

describe "Search", js: true do
  context "general" do
    it "renders the search container properly" do
      VCR.use_cassette("search#check", record: :new_episodes) do
        visit sections_path

        expect(page).to have_content("Trade Tariff: look up commodity codes, duty and VAT rates")
        expect(page).to have_content("Search the tariff")

        expect(page.find("#select2-q-container")).to be_present
      end
    end
  end

  context "real" do
    it "fetches data from the server as we type" do
      VCR.use_cassette("search#gold", record: :new_episodes) do
        visit sections_path

        page.find("#select2-q-container").click

        page.find(".select2-search__field").set("gold")
        sleep 2

        expect(page.find(".select2-results__option--highlighted").text).to eq("gold")
        sleep 2

        using_wait_time 10 do
          expect(page.find_all(".select2-results__option").length).to be > 1
        end

        expect(page.find(".select2-results__option--highlighted").text).to eq("gold")
        expect(page).to have_content("gold - gold coin")

        page.find(".select2-results__option--highlighted").click

        # trying to see if redirect done by JS needs some sleep to be caught up
        sleep 2

        expect(page).to have_content("Search results for ‘gold’")
      end
    end
  end

  context "404" do
    it "handles no results found" do
      VCR.use_cassette("search#gibberish", record: :new_episodes) do
        visit sections_path

        page.find("#select2-q-container").click

        page.find(".select2-search__field").set("dsauidoasuiodsa")

        sleep 2

        expect(page.find_all(".select2-results__option").length).to eq(1)
        expect(page.find(".select2-results__option--highlighted").text).to eq("dsauidoasuiodsa")
        sleep 2

        page.find(".select2-results__option--highlighted").click

        # trying to see if redirect done by JS needs some sleep to be caught up
        sleep 2

        expect(page).to have_content("Search results for ‘dsauidoasuiodsa’")
        expect(page).to have_content("There are no results matching your query.")
      end
    end
  end

  context 'quota search' do
    before(:each) do
      Rails.cache.clear
    end

    context 'quota search link on page header' do
      it 'should contain link to quota search page' do
        VCR.use_cassette('search#quota_search_header', record: :new_episodes) do
          visit sections_path
          expect(page).to have_content('Quotas')
        end
      end
    end

    context 'quota search form' do
      it 'should contain quota search params inputs' do
        VCR.use_cassette('search#quota_search_form', record: :new_episodes) do
          visit quota_search_path

          expect(page).to have_content('Quotas')

          expect(page.find('#goods_nomenclature_item_id')).to be_present
          expect(page.find('#geographical_area_id')).to be_present
          expect(page.find('#order_number')).to be_present
          expect(page.find('#critical')).to be_present
          expect(page.find('#status')).to be_present
          expect(page.find('#quota-search-year-2016', visible: :all)).to be_present
          expect(page.find('#quota-search-year-2017', visible: :all)).to be_present
          expect(page.find('#quota-search-year-2018', visible: :all)).to be_present
          expect(page.find('#quota-search-year-2019', visible: :all)).to be_present
          expect(page.find('#quota-search-year-2020', visible: :all)).to be_present
          expect(page.find('input[name="new_search"]')).to be_present

          expect(page).not_to have_content('Quota search results')
        end
      end
    end

    context 'quota search results' do
      it 'should perform search and render results' do
        VCR.use_cassette('search#quota_search_results', record: :new_episodes) do
          visit quota_search_path

          expect(page).to have_content('Quotas')

          page.find('#goods_nomenclature_item_id').set('0301')
          page.find('#order_number').set('0906')
          page.find('#quota-search-year-2019', visible: :all).click
          page.find('input[name="new_search"]').click

          using_wait_time 10 do
            expect(page).to have_content('Quota search results')
            expect(page).to have_content('090671')
            expect(page).to have_content('0301919011')
            expect(page).to have_content('Faroe Islands (FO)')
          end
        end
      end
    end
  end

  context 'additional code search' do
    before(:each) do
      Rails.cache.clear
    end

    context 'additional code search link on page header' do
      it 'should contain link to additional code search page' do
        VCR.use_cassette('search#additional_code_search_header', record: :new_episodes) do
          visit sections_path
          expect(page).to have_content('Additional code')
        end
      end
    end

    context 'additional code search form' do
      it 'should contain additional code search params inputs' do
        VCR.use_cassette('search#additional_code_search_form', record: :new_episodes) do
          visit additional_code_search_path

          expect(page).to have_content('Additional code')

          expect(page.find('#code')).to be_present
          expect(page.find('#description')).to be_present
          expect(page.find('input[name="new_search"]')).to be_present

          expect(page).not_to have_content('Additional code search results')
        end
      end
    end

    context 'additional code search results' do
      it 'should perform search and render results' do
        VCR.use_cassette('search#additional_code_search_results', record: :new_episodes) do
          visit additional_code_search_path

          expect(page).to have_content('Additional code')

          page.find('#code').set('119')
          page.find('input[name="new_search"]').click

          using_wait_time 10 do
            expect(page).to have_content('Additional code search results')
            expect(page).to have_content('B119')
            expect(page).to have_content('Wenzhou Jiangnan Steel Pipe Manufacturing, Co. Ltd., Yongzhong')
            expect(page).to have_content('Of stainless steel')
          end
        end
      end
    end
  end
  
  context 'certificate search' do
    before(:each) do
      Rails.cache.clear
    end

    context 'certificate search link on page header' do
      it 'should contain link to certificate search page' do
        VCR.use_cassette('search#certificate_search_header', record: :new_episodes) do
          visit sections_path
          expect(page).to have_content('Certificate')
        end
      end
    end

    context 'certificate search form' do
      it 'should contain certificate search params inputs' do
        VCR.use_cassette('search#certificate_search_form', record: :new_episodes) do
          visit certificate_search_path

          expect(page).to have_content('Certificate')

          expect(page.find('#code')).to be_present
          expect(page.find('#description')).to be_present
          expect(page.find('input[name="new_search"]')).to be_present

          expect(page).not_to have_content('Certificate search results')
        end
      end
    end

    context 'certificate search results' do
      it 'should perform search and render results' do
        VCR.use_cassette('search#certificate_search_results', record: :new_episodes) do
          visit certificate_search_path

          expect(page).to have_content('Certificate')

          page.find('#code').set('119')
          page.find('input[name="new_search"]').click

          using_wait_time 10 do
            expect(page).to have_content('Certificate search results')
            expect(page).to have_content('C119')
            expect(page).to have_content('Authorised Release Certificate — EASA Form 1 (Appendix I to Annex I to Regulation (EU) No 748/2012), or equivalent certificate')
            expect(page).to have_content('Carbon dioxide')
          end
        end
      end
    end
  end
end
