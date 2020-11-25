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

  it 'displays today\'s date, if the searched-for date is past BREXIT_DATE, but the current date is before BREXIT_DATE' do
    now = DateTime.new(2020, 11, 23, 12, 0, 0)
    eu_exit = Date.parse(ENV['BREXIT_DATE'] || '2021-01-01')

    visit sections_path(day: now.yesterday.day, month: now.month, year: now.year)

    expect(page).to have_content "This tariff is for #{now.yesterday.strftime('%-d %B %Y')}"

    click_link 'Change date'

    page.execute_script("$('#tariff_date_year').val('#{eu_exit.year}')")
    page.execute_script("$('#tariff_date_month').val('#{eu_exit.month}')")
    page.execute_script("$('#tariff_date_day').val('#{eu_exit.day + 1}')")

    Timecop.freeze(now) do
      click_link 'Set date'

      expect(page).to have_content "This tariff is for #{now.strftime('%-d %B %Y')}"
      expect(page).to have_content "Change date"
    end
  end

  it 'displays the searched-for date, if the searched-for date is past BREXIT_DATE, and the current date is past BREXIT_DATE' do
    post_eu_exit_date = DateTime.new(2021, 1, 1, 12, 0, 0)
    searched_for_date = DateTime.new(2021, 2, 2, 12, 0, 0)

    Timecop.freeze(post_eu_exit_date) do
      visit sections_path

      expect(page).to have_content "This tariff is for #{(post_eu_exit_date).strftime('%-d %B %Y')}"

      click_link 'Change date'

      page.execute_script("$('#tariff_date_year').val('#{searched_for_date.year}')")
      page.execute_script("$('#tariff_date_month').val('#{searched_for_date.month}')")
      page.execute_script("$('#tariff_date_day').val('#{searched_for_date.day}')")

      click_link 'Set date'

      expect(page).to have_content "This tariff is for #{(searched_for_date).strftime('%-d %B %Y')}"
    end
  end
end
