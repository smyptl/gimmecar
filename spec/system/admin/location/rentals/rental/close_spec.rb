require 'spec_helper'
require 'system/admin/helpers/path_helper'
require 'system/admin/helpers/user_and_location'

require 'factories/rentals'

describe 'close rental', type: :system, js: true do
  include_context :login_user_and_select_location

  scenario 'success' do
    pickup_odometer = 550
    drop_off_odometer = pickup_odometer + 500
    rental = create(:rental, :open,
                    pickup_location: location,
                    pickup: (Time.current - 1.day),
                    pickup_odometer: pickup_odometer,
                    pickup_fuel: 10)

    expect(rental.closed?).to eq(false)

    visit_admin admin_location_rental_path(slug: location.slug, id: rental.number)


    expect(page).to have_content(rental.number)
    find("a[data-toggle='dropdown']").click
    click_button('Close')
    expect(page).to have_content('Close')
    fill_in 'Vehicle Odometer', with: drop_off_odometer
    within('div.popup') do
      click_button('Close')
    end
    expect(page).to have_content('Closed')

    expect(Rental.count).to eq(1)
    rental = Rental.first
    expect(rental.closed?).to eq(true)
    expect(rental.drop_off_fuel).to eq(10)
    expect(rental.drop_off_odometer).to eq(drop_off_odometer)

    vehicle = rental.vehicle
    expect(vehicle.dirty?).to eq(true)
  end
end
