require 'spec_helper'
require 'features/admin/helpers/path_helper'
require 'features/admin/helpers/user_and_location'

require 'helpers/stripe_helper'

require 'factories/rentals'

feature 'view reservations', js: true do
  include_context :login_user_and_select_location

  scenario 'loads correctly' do
    reservation = create(:reservation, pickup_location: location, vehicle_type: 'compact')

    visit_admin admin_location_reservations_path(:slug => location.slug)

    expect(page).to have_content(reservation.driver.name)
    expect(page).to have_content('Compact')
  end
end
