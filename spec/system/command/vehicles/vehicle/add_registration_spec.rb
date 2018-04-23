require 'spec_helper'
require 'system/command/helpers/path_helper'
require 'system/command/helpers/user'

require 'factories/vehicles'

describe 'Add Registration', type: :system, js: true do
  include_context :login_user

  scenario 'success' do
    vehicle = create(:vehicle)

    visit_command command_vehicle_path(id: vehicle.vin)

    expect(page).to have_content(vehicle.vin)
    find("a[data-toggle='dropdown']").click
    click_button('Add Registration')

    expect(page).to have_content('Add Registration')
    expect(page).to have_content('asdf')
  end
end
