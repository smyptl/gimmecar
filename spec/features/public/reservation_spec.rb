require 'spec_helper'

feature "Reservations", js: true do

  scenario "create reservation" do
    visit root_path
    expect(page.driver.console_messages).to eq("ASDF")
    #click_button "View Rates"
  end
end
