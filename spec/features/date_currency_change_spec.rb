require "spec_helper"

describe "Date & Currency change", js: true, vcr: {
  cassette_name: "date_currency",
  record: :once,
  match_requests_on: [:path, :query]
} do

  it "displays the current date" do
    visit sections_path(day: 01, month: 02, year: 2019)

    expect(page).to have_content "This tariff is for 1 February 2019"
  end

  it "is able to change dates and go back in time" do
    visit sections_path(day: 01, month: 02, year: 2019)

    expect(page).to have_content "This tariff is for 1 February 2019"
    expect(page).to have_content "Change date"

    click_link "Change date"

    expect(page).to have_content "Set date"

    page.execute_script("$('#tariff_date_year').val('2018')")
    page.execute_script("$('#tariff_date_month').val('12')")

    click_link "Set date"

    expect(page).to have_content "This tariff is for 1 December 2018"
    expect(page).to have_content "Change date"
  end
end
