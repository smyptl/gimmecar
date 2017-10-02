require 'spec_helper'

require 'factories/locations'
require 'factories/rates'
require 'factories/tax_rates'

feature "Reservations", js: true do

  scenario "create reservation" do
    visit root_path

    location = create(:location)
    create(:tax_rate, location: location)
    create(:rate, :default, vehicle_type: :mid_size, location: location, amount: 3500)


    select 'Mid-Size', from: 'Vehicle Type'
    click_button "View Rates"

    within("#rental-summary") do
      expect(page).to have_content("Rental Details")
      expect(page).to have_content("Rates")
      expect(page).to have_content("Taxes & Fees")
      click_button "Reserve"
    end

    within('#rental-reserve') do
      expect(page).to have_content('Name')

      fill_in :name_first, with: 'John'
      fill_in :name_last, with: 'Doe'
      fill_in 'Email', with: 'test@gmail.com'
      fill_in 'Phone #', with: 9012351234
    end

    click_button 'Reserve Car'

    expect(page).to have_content('Thanks for choosing us, John!!!')
    expect(page).to have_content('Rental Details')
    expect(page).to have_content('Confirmation Number')

    expect(ActionMailer::Base.deliveries.count).to eq(2)
  end
end
