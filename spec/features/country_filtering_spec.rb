require "spec_helper"

describe "Search", js: true, vcr: {
  cassette_name: "country_filtering",
  record: :new_episodes,
  match_requests_on: [:query, :path]
} do

  it "is possible to filter measures by country" do

    visit commodity_path("0101210000", as_of: '2019-03-05')

    sleep 2

    within ".nav-tabs" do
      click_on "Import"
    end

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

    page.find(".reset-country-picker", visible: true).click

    sleep 2
    expect(page.find("#select2-import_search_country-container").text).to eq("All countries")
  end
end
