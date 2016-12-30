require 'spec_helper'

feature "Reservations", js: true do

  scenario "create reservation" do
    visit root_path

    click_button "View Rates"

    within("#rental-summary") do
      expect(page).to have_content("Rental Details")
      expect(page).to have_content("Rates")
      expect(page).to have_content("Taxes & Fees")
      click_button "Reserve"
    end

    click_button "Reserve Car"
    expect(page.driver.console_messages.last).to eq(nil)
    expect(page).to have_content("can't be blank")
  end
end
