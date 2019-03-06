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
end
