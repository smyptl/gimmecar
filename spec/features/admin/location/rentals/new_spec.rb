require 'spec_helper'
require 'features/admin/helpers/path_helper'
require 'features/admin/helpers/user_and_location'

require 'factories/vehicles'

feature 'Login', js: true do
  include_context :login_user_and_select_location

  scenario 'login user' do
    vehicle_1 = create(:vehicle, original_location: location, location: location)

    visit_admin location_rentals_new_path(:slug => location.slug)

    expect(page).to have_content('Rental: Details')
    click_on 'Continue'

    expect(page).to have_content('Rental: Rates')
    expect(page).to have_content('Rental Details')
    expect(page).to have_content('Estimated Total:')
    click_on 'Continue'

    expect(page).to have_content('Rental: Drivers')

    driver = build_stubbed(:driver)

    fill_in 'driver_first_name',              with: driver.first_name
    fill_in 'driver_last_name',               with: driver.last_name

    fill_in 'driver_license_number',          with: driver.license_number
    fill_in 'driver_license_state',           with: driver.license_state
    fill_in 'driver_license_country',         with: driver.license_country
    fill_in 'driver_license_expiration_date', with: driver.license_expiration_date.strftime('%m/%d/%Y')

    fill_in 'driver_address_1',               with: driver.address_1
    fill_in 'driver_address_2',               with: driver.address_2
    fill_in 'driver_city',                    with: driver.city
    fill_in 'driver_state',                   with: driver.state
    fill_in 'driver_zip_code',                with: driver.zip_code
    fill_in 'driver_country',                 with: driver.country

    fill_in 'driver_date_of_birth',           with: driver.date_of_birth
    select driver.gender, from: 'driver_gender'

    fill_in 'driver_email',                   with: driver.email
    fill_in 'driver_cell_phone_number',       with: driver.cell_phone_number
    fill_in 'driver_home_phone_number',       with: driver.home_phone_number

    driver_insurance = build_stubbed(:insurance_policy)

    fill_in 'driver_insurance_company_name',       with: driver_insurance.company_name
    fill_in 'driver_insurance_policy_number',      with: driver_insurance.policy_number
    fill_in 'driver_insurance_effective_date',     with: driver_insurance.effective_date.strftime('%m/%d/%Y')
    fill_in 'driver_insurance_expiration_date',    with: driver_insurance.expiration_date.strftime('%m/%d/%Y')
    fill_in 'driver_insurance_agent_name',         with: driver_insurance.agent
    fill_in 'driver_insurance_phone_number',       with: driver_insurance.phone_number

    check 'Insurance Verified?'
    fill_in 'driver_insurance_verify_agent',       with: driver_insurance.verify_agent
    fill_in 'driver_insurance_verify_call_center', with: driver_insurance.verify_call_center
    fill_in 'driver_insurance_verify_date',        with: driver_insurance.verify_date.strftime('%m/%d/%Y')

    expect(page).to have_content('Add Additional Driver')

    click_on 'Continue'

    expect(page).to have_content('Rental: Vehicle')
    expect(page).to have_content(vehicle_1.license_number)
    find('td', text: vehicle_1.license_number).click
    fill_in 'Vehicle Odometer', with: 40512
    expect(page).to have_content('50%')
    click_on 'Continue'

    #expect(page).to have_content('Rental: Add-Ons')
    #click_on 'Continue'

    expect(page).to have_content('Rental: Financial Responsibility')
    expect(page).to have_content('Notice About Your Financial Responibility')
    expect(page).to have_content("#{driver_first_name} #{driver_last_name}")
    click_on 'Continue'

    expect(page).to have_content('Rental: Terms and Conditions')
    expect(page).to have_content('Total:')
    expect(page).to have_content('Rental Agreement Terms and Conditions')
    expect(page).to have_content("#{driver_first_name} #{driver_last_name}")
    click_on 'Continue'

    expect(page).to have_content('Rental: Payment')
    click_on 'Continue'
  end
end
