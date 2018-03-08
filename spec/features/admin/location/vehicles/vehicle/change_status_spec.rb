require 'spec_helper'
require 'features/admin/helpers/path_helper'
require 'features/admin/helpers/user_and_location'

require 'factories/vehicles'

feature 'change vehicle status', js: true do
  include_context :login_user_and_select_location

  scenario 'success' do
    vehicle = create(:vehicle, status: :dirty, location: location)
    expect(vehicle.status).to eq('dirty')

    visit_admin admin_location_vehicle_path(slug: location.slug, id: vehicle.vin)

    expect(page).to have_content(vehicle.vin)
    find("a[data-toggle='dropdown']").trigger('click')
    click_button('Change Status')
    expect(page).to have_content('Change Status')
    select 'Clean', from: 'vehicle_status'
    click_button('Update')

    expect(page).to have_css('svg#clean')


    expect(Vehicle.count).to eq(1)
    vehicle = Vehicle.first
    expect(vehicle.status).to eq('clean')
  end
end
