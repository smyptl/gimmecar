require 'spec_helper'
require 'system/admin/helpers/path_helper'
require 'system/admin/helpers/user_and_location'

require 'factories/vehicles'

describe 'change vehicle status', type: :system, js: true do
  include_context :login_user_and_select_location

  scenario 'success' do
    vehicle = create(:vehicle, status: :dirty, location: location)
    expect(vehicle.status).to eq('dirty')

    visit_admin admin_location_vehicle_path(slug: location.slug, id: vehicle.vin)

    expect(page).to have_content(vehicle.vin)
    find("a[data-toggle='dropdown']").click
    click_button('Change Status')
    expect(page).to have_content('Change Status')
    find('td', text: 'Clean').click
    click_button('Change')

    expect(page).to have_css('svg#clean')


    expect(Vehicle.count).to eq(1)
    vehicle = Vehicle.first
    expect(vehicle.status).to eq('clean')
  end
end
