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

    within("#rental-reserve") do
      fill_in :first_name, with: 'John'
      fill_in :last_name, with: 'Doe'
      fill_in 'Email', with: 'test@gmail.com'
      fill_in 'Phone #', with: 9012351234
    end

    click_button 'Reserve Car'

    expect(page).to have_content('Rental Confirmation')
    expect(page).to have_content('Confirmation #')

    expect(ActionMailer::Base.deliveries.count).to eq(2)
  end
end
