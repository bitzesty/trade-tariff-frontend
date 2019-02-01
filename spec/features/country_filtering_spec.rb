require "spec_helper"

describe "Search", js: true, vcr: {
  cassette_name: "country_filtering",
  record: :new_episodes,
  match_requests_on: [:query, :path]
} do

  before {
    visit commodity_path("0201300020", day: 31, month: 5, year: 2014)

    within ".nav-tabs" do
      click_on "Import"
    end
  }

  it "is possible to filter measures by country" do
    sleep 2
    expect(page.find("#select2-import_search_country-container").text).to eq("All countries")

    page.find("#select2-import_search_country-container").click

    page.find(".select2-search__field").set "United States of America"
    sleep 2

    expect(page.find_all(".select2-results__option").length).to eq(1)
    expect(page.find(".select2-results__option--highlighted").text).to eq("United States of America (US)");

    page.find(".select2-results__option--highlighted").click

    sleep 2

    expect(page.find("#select2-import_search_country-container").text).to eq("United States of America (US)")
    expect(page).to have_content("Measures for United States of America")

    page.find(".reset-country-picker").click

    sleep 2
    expect(page.find("#select2-import_search_country-container").text).to eq("All countries")
  end
end
