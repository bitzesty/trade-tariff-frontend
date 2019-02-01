require "spec_helper"

describe "Date & Currency change", js: true, vcr: {
  cassette_name: "date_currency",
  record: :new_episodes,
  match_requests_on: [:query, :path]
} do

  it "displays the current date" do
    visit sections_path

    expect(page).to have_content "This tariff is for 1 February 2019"
  end

  it "is able to change dates and go back in time" do
    visit sections_path

    expect(page).to have_content "This tariff is for 1 February 2019"
    expect(page).to have_content "Change date"

    click_link "Change date"

    expect(page).to have_content "Set date"

    select 'December', from: 'tariff_date_month'
    select '2018', from: 'tariff_date_year'

    click_link "Set date"

    expect(page).to have_content "This tariff is for 1 December 2018"
    expect(page).to have_content "Change date"
  end
end
