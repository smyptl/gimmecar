require 'spec_helper'
require 'system/helpers/file_upload'
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
    fill_in 'Effective Date', with: '1/1/18'
    fill_in 'Expiration Date', with: '1/1/19'
    attach_file('registration', upload_pdf)
    within('div.popup') do
      click_button('Add')
    end

    expect(page).to_not have_content('Add Registration')

    expect(VehicleRegistration.count).to eq(1)
    vehicle_registration = VehicleRegistration.first
    expect(vehicle_registration.vehicle).to eq(vehicle)
    expect(vehicle_registration.date_effective).to eq(Date.new(2018, 1, 1))
    expect(vehicle_registration.date_expiration).to eq(Date.new(2019, 1, 1))
    expect(vehicle_registration.document).to_not eq(nil)
  end
end
