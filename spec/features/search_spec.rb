require "spec_helper"

describe "Search", js: true, vcr: {
  cassette_name: "search#gold",
  match_requests_on: [:query, :path, :body]
} do

  it "renders the search container properly" do
    visit sections_path

    expect(page).to have_content("Trade Tariff: look up commodity codes, duty and VAT rates")
    expect(page).to have_content("Search the tariff")

    expect(page.find("#select2-q-container")).to be_present
  end

  it "fetches data from the server as we type" do
    visit sections_path

    page.find("#select2-q-container").click

    page.find(".select2-search__field").set("gold")

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

  it "handles no results found" do
    visit sections_path

    page.find("#select2-q-container").click

    page.find(".select2-search__field").set("dsauidoasuiodsa")

    expect(page.find_all(".select2-results__option").length).to eq(1)
    expect(page.find(".select2-results__option--highlighted").text).to eq("dsauidoasuiodsa")

    page.find(".select2-results__option--highlighted").click

    # trying to see if redirect done by JS needs some sleep to be caught up
    sleep 2

    expect(page).to have_content("Search results for ‘dsauidoasuiodsa’")
    expect(page).to have_content("There are no results matching your query.")
  end
end
