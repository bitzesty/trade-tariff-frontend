require 'spec_helper'

describe 'JS behaviour', js: true do
  before do
    VCR.use_cassette('geographical_areas#countries') do
      VCR.use_cassette('commodities#show_0201300020') do
        visit commodity_path('0201300020', day: 31, month: 5, year: 2014)
      end
    end
  end

  context 'when clicking tabs' do
    it '*overview* tab is shown' do
      expect(page).to have_selector('#overview-enhanced', visible: true)
    end

    it '*import* tab is hidden' do
      expect(page).not_to have_selector('#import-enhanced', visible: true)
    end

    describe 'switch tabs' do
      before do
        click_import_tab
      end

      it '*overview* tab is hidden' do
        expect(page).not_to have_selector('#overview-enhanced', visible: true)
      end

      it '*import* tab is shown' do
        expect(page).to have_selector('#import-enhanced', visible: true)
      end
    end
  end

  context 'when clicking popups' do
    before do
      expect(page).not_to have_selector('#popup .info-content', visible: true) # ensure popup is hidden

      click_import_tab

      within '#measure-3319435' do
        click_on 'Conditions'
      end
    end

    it 'displays the popup' do
      expect(page).to have_selector('#popup .info-content', visible: true)
    end

    it 'displays the popup content' do
      expect(page).to have_content('Import control - CITES for ERGA OMNES')
    end
  end

  describe 'legal base column hiding' do
    context 'without the environment variable set' do
      before do
        @current_legal_base = ENV['HIDE_REGULATIONS'].dup
        ENV.delete('HIDE_REGULATIONS')
        VCR.use_cassette('commodities#show_0201100021_legal_base_visible_no_env') do
          visit commodity_path('0201100021', day: 21, month: 2, year: 2019, no_env: true)
        end

        click_import_tab
      end

      after do
        ENV['HIDE_REGULATIONS'] = @current_legal_base
      end

      it 'displays the legal base column' do
        expect(page).to have_content('Legal base')
      end

      it 'displays the current regulations' do
        expect(page).to have_content('R2204/99')
      end
    end

    context 'with the environment variable set' do
      context 'with the column showing' do
        before do
          @current_legal_base = ENV['HIDE_REGULATIONS'].dup
          ENV['HIDE_REGULATIONS'] = 'false'
          VCR.use_cassette('commodities#show_0201100021_legal_base_visible') do
            visit commodity_path('0201100021', day: 21, month: 2, year: 2019)
          end

          click_import_tab
        end

        after do
          ENV['HIDE_REGULATIONS'] = @current_legal_base
        end

        it 'displays the legal base column' do
          expect(page).to have_content('Legal base')
        end

        it 'displays the current regulations' do
          expect(page).to have_content('R2204/99')
        end
      end

      context 'with the column hidden' do
        before do
          @current_legal_base = ENV['HIDE_REGULATIONS'].dup
          ENV['HIDE_REGULATIONS'] = 'true'

          VCR.use_cassette('commodities#show_0201100021_legal_base_hidden') do
            visit commodity_path('0201100021', day: 21, month: 2, year: 2019, cache_buster: 'reload')
          end

          click_import_tab
        end

        after do
          ENV['HIDE_REGULATIONS'] = @current_legal_base
        end

        it 'does not display the legal base column' do
          expect(page).not_to have_content('Legal base')
        end

        it 'does not display the current regulations' do
          expect(page).not_to have_content('R2204/99')
        end
      end
    end
  end
end

def click_import_tab
  within '.nav-tabs' do
    click_on 'Import'
  end
end
