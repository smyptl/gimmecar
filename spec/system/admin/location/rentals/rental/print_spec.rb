require 'spec_helper'
require 'system/admin/helpers/path_helper'
require 'system/admin/helpers/user_and_location'

require 'factories/rentals'

describe 'print', type: :system, js: true do
  include_context :login_user_and_select_location

  scenario 'has appropriate print information' do
    rental = create(:rental, pickup_location: location)

    visit_admin admin_location_rental_print_path(slug: location.slug, rental_id: rental.number)

    expect(page).to have_content(rental.pickup_location_description)
    expect(page).to have_content(rental.driver.name_full)
    expect(page).to have_content(rental.vehicle_make_model)
    expect(page).to have_content('Rental Details')
    expect(page).to have_content('Sales Tax')
  end
end
