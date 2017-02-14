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

    driver_first_name = Faker::Name.first_name
    fill_in 'driver_first_name', with: driver_first_name
    driver_last_name = Faker::Name.last_name
    fill_in 'driver_last_name', with: driver_last_name

    driver_license_number = '123JAS12'
    fill_in 'driver_license_number', with: driver_license_number
    driver_license_state = Faker::Address.state
    fill_in 'driver_license_state', with: driver_license_state
    driver_license_country = Faker::Address.country
    fill_in 'driver_license_country', with: driver_license_country
    driver_license_expiration_date = Date.today + 1.year
    fill_in 'driver_license_expiration_date', with: driver_license_expiration_date.strftime('%m/%d/%Y')

    driver_address_1 = Faker::Address.street_address
    fill_in 'driver_address_1', with: driver_address_1
    driver_address_2 = Faker::Address.secondary_address
    fill_in 'driver_address_2', with: driver_address_2
    driver_city = Faker::Address.city
    fill_in 'driver_city', with: driver_city
    driver_state = Faker::Address.state
    fill_in 'driver_state', with: driver_state
    driver_zip_code = Faker::Address.zip_code
    fill_in 'driver_zip_code', with: driver_zip_code
    driver_country = Faker::Address.country
    fill_in 'driver_country', with: driver_country

    driver_date_of_birth = '1/5/1989'
    fill_in 'driver_date_of_birth', with: driver_date_of_birth
    driver_gender = Faker::Demographic.sex
    select driver_gender, from: 'driver_gender'

    driver_email = Faker::Internet.email
    fill_in 'driver_email', with: driver_email
    driver_cell_phone_number = Faker::PhoneNumber.cell_phone
    fill_in 'driver_cell_phone_number', with: driver_cell_phone_number
    driver_home_phone_number = Faker::PhoneNumber.phone_number
    fill_in 'driver_home_phone_number', with: driver_home_phone_number

    driver_insurance_company_name = Faker::Company.name
    fill_in 'driver_insurance_company_name', with: driver_insurance_company_name
    driver_insurance_policy_number = SecureRandom.hex(10)
    fill_in 'driver_insurance_policy_number', with: driver_insurance_policy_number
    driver_insurance_effective_date = Date.today - 1.month
    fill_in 'driver_insurance_effective_date', with: driver_insurance_effective_date.strftime('%m/%d/%Y')
    driver_insurance_expiration_date = Date.today + 11.month
    fill_in 'driver_insurance_expiration_date', with: driver_insurance_expiration_date.strftime('%m/%d/%Y')
    driver_insurance_agent_name = Faker::Name.name
    fill_in 'driver_insurance_agent_name', with: driver_insurance_agent_name
    driver_insurance_phone_number = Faker::PhoneNumber.phone_number
    fill_in 'driver_insurance_phone_number', with: driver_insurance_phone_number

    expect(page).to have_content('Add Additional Driver')

    click_on 'Continue'

    expect(page).to have_content('Rental: Vehicle')
    expect(page).to have_content(vehicle_1.license_number)
    find('td', text: vehicle_1.license_number).click
    fill_in 'Vehicle Odometer', with: 40512
    expect(page).to have_content('50%')
    click_on 'Continue'

    expect(page).to have_content('Rental: Financial Responsibility')
    expect(page).to have_content("#{driver_first_name} #{driver_last_name}")
    click_on 'Continue'

    expect(page).to have_content('Rental: Terms and Conditions')
    expect(page).to have_content("#{driver_first_name} #{driver_last_name}")
    click_on 'Continue'

    expect(page).to have_content('Rental: Payment')
  end
end
