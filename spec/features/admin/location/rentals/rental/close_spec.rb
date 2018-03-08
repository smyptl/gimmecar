require 'spec_helper'
require 'features/admin/helpers/path_helper'
require 'features/admin/helpers/user_and_location'

require 'factories/rentals'

feature 'close rental', js: true do
  include_context :login_user_and_select_location

  scenario 'success' do
    rental = create(:rental, :open, pickup_location: location, pickup: (Time.current - 1.day))
    expect(rental.closed?).to eq(false)

    visit_admin admin_location_rental_path(slug: location.slug, id: rental.number)

    expect(page).to have_content(rental.number)
    find("a[data-toggle='dropdown']").trigger('click')
    click_button('Close')
    expect(page).to have_content('Close')
    fill_in 'Vehicle Odometer', with: 1200
    within('div.popup') do
      click_button('Close')
    end
    expect(page).to have_content('Closed')

    expect(Rental.count).to eq(1)
    rental = Rental.first
    expect(rental.closed?).to eq(true)
    expect(rental.drop_off_fuel).to eq(10)
    expect(rental.drop_off_odometer).to eq(1200)

    vehicle = rental.vehicle
    expect(vehicle.dirty?).to eq(true)
  end
end
