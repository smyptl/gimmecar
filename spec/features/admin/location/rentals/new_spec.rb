require 'spec_helper'
require 'features/admin/helpers/path_helper'
require 'features/admin/helpers/user_and_location'

require 'helpers/stripe_helper'

require 'factories/vehicles'
require 'factories/drivers'
require 'factories/insurance_policies'
require 'factories/rates'
require 'factories/tax_rates'

feature 'Login', js: true do
  include_context :login_user_and_select_location

  scenario 'login user' do
    tax_rate = create(:tax_rate, location: location)
    vehicle_1 = create(:vehicle, original_location: location, location: location)

    create(:rate, :default, vehicle_type: :mid_size, location: location, amount: 3500)

    visit_admin location_rentals_new_path(:slug => location.slug)

    expect(page).to have_content('Rental: Details')
    click_on 'Continue'

    expect(page).to have_content('Rental: Rates')
    expect(page).to have_content('Rental Details')
    expect(page).to have_content('Estimated Total:')
    click_on 'Continue'

    expect(page).to have_content('Rental: Drivers')

    driver_stub = build_stubbed(:driver)

    fill_in 'driver_first_name',              with: driver_stub.first_name
    fill_in 'driver_last_name',               with: driver_stub.last_name

    fill_in 'driver_license_number',          with: driver_stub.license_number
    fill_in 'driver_license_state',           with: driver_stub.license_state
    fill_in 'driver_license_country',         with: driver_stub.license_country
    fill_in 'driver_license_expiration_date', with: driver_stub.license_expiration_date.strftime('%m/%d/%Y')

    fill_in 'driver_address_1',               with: driver_stub.address_1
    fill_in 'driver_address_2',               with: driver_stub.address_2
    fill_in 'driver_city',                    with: driver_stub.city
    fill_in 'driver_state',                   with: driver_stub.state
    fill_in 'driver_zip_code',                with: driver_stub.zip_code
    fill_in 'driver_country',                 with: driver_stub.country

    fill_in 'driver_date_of_birth',           with: driver_stub.date_of_birth.strftime('%m/%d/%Y')
    select driver_stub.gender.capitalize, from: 'driver_gender'

    fill_in 'driver_email',                   with: driver_stub.email
    fill_in 'driver_cell_phone_number',       with: driver_stub.cell_phone_number
    fill_in 'driver_home_phone_number',       with: driver_stub.home_phone_number

    driver_insurance_stub = build_stubbed(:insurance_policy)

    fill_in 'driver_insurance_company_name',       with: driver_insurance_stub.company_name
    fill_in 'driver_insurance_policy_number',      with: driver_insurance_stub.policy_number
    fill_in 'driver_insurance_effective_date',     with: driver_insurance_stub.effective_date.strftime('%m/%d/%Y')
    fill_in 'driver_insurance_expiration_date',    with: driver_insurance_stub.expiration_date.strftime('%m/%d/%Y')
    fill_in 'driver_insurance_agent',              with: driver_insurance_stub.agent
    fill_in 'driver_insurance_phone_number',       with: driver_insurance_stub.phone_number

    check 'Insurance Verified?'
    fill_in 'driver_insurance_verify_agent',       with: driver_insurance_stub.verify_agent
    fill_in 'driver_insurance_verify_call_center', with: driver_insurance_stub.verify_call_center
    fill_in 'driver_insurance_verify_date',        with: driver_insurance_stub.verify_date.strftime('%m/%d/%Y')

    expect(page).to have_content('Add Additional Driver')

    click_on 'Continue'

    expect(page).to have_content('Rental: Vehicle')
    expect(page).to have_content(vehicle_1.license_number)
    find('td', text: vehicle_1.license_number).click
    fill_in 'Vehicle Odometer', with: 40512
    expect(page).to have_content('100%')
    click_on 'Continue'

    #expect(page).to have_content('Rental: Add-Ons')
    #click_on 'Continue'

    expect(page).to have_content('Rental: Financial Responsibility')
    expect(page).to have_content('Notice About Your Financial Responibility')
    expect(page).to have_content("#{driver_stub.first_name} #{driver_stub.last_name}")
    click_on 'Continue'

    expect(page).to have_content('Rental: Terms & Conditions')
    expect(page).to have_content('Total:')
    expect(page).to have_content('Rental Agreement Terms and Conditions')
    expect(page).to have_content("#{driver_stub.first_name} #{driver_stub.last_name}")
    click_on 'Continue'

    expect(page).to have_content('Rental: Payment')

    stripe_iframe = all('iframe[name=__privateStripeFrame4]').last
    puts stripe_iframe
    Capybara.within_frame stripe_iframe do
      find('input[name=cardnumber]').set(CARD_TYPE[:visa])
      find('input[name="exp-date"]').set('01/20')
      find('input[name="cvc"]').set('123')
      find('input[name="postal"]').set('90210')
    end
    click_on 'Continue'

    expect(page).to have_content("#{driver_stub.first_name} #{driver_stub.last_name}")

    expect(Driver.count).to eq(1)
    driver = Driver.first
    expect(driver.first_name).to eq(driver_stub.first_name)
    expect(driver.last_name).to eq(driver_stub.last_name)
    expect(driver.gender).to eq(driver_stub.gender)
    expect(driver.address_1).to eq(driver_stub.address_1)
    expect(driver.address_2).to eq(driver_stub.address_2)
    expect(driver.city).to eq(driver_stub.city)
    expect(driver.state).to eq(driver_stub.state)
    expect(driver.zip_code).to eq(driver_stub.zip_code)
    expect(driver.country).to eq(driver_stub.country)
    expect(driver.home_phone_number).to eq(driver_stub.home_phone_number)
    expect(driver.cell_phone_number).to eq(driver_stub.cell_phone_number)
    expect(driver.email).to eq(driver_stub.email)
    expect(driver.date_of_birth).to eq(driver_stub.date_of_birth)
    expect(driver.license_number).to eq(driver_stub.license_number)
    expect(driver.license_state).to eq(driver_stub.license_state)
    expect(driver.license_country).to eq(driver_stub.license_country)
    expect(driver.license_expiration_date).to eq(driver_stub.license_expiration_date)

    expect(InsurancePolicy.count).to eq(1)
    insurance_policy = InsurancePolicy.first
    expect(insurance_policy.company_name).to eq(driver_insurance_stub.company_name)
    expect(insurance_policy.agent).to eq(driver_insurance_stub.agent)
    expect(insurance_policy.policy_number).to eq(driver_insurance_stub.policy_number)
    expect(insurance_policy.phone_number).to eq(driver_insurance_stub.phone_number)
    expect(insurance_policy.effective_date).to eq(driver_insurance_stub.effective_date)
    expect(insurance_policy.expiration_date).to eq(driver_insurance_stub.expiration_date)
    expect(insurance_policy.verify_date).to eq(driver_insurance_stub.verify_date)
    expect(insurance_policy.verify_agent).to eq(driver_insurance_stub.verify_agent)
    expect(insurance_policy.verify_call_center).to eq(driver_insurance_stub.verify_call_center)
    expect(insurance_policy.driver).to eq(driver)

    expect(Rental.count).to eq(1)
    rental = Rental.first
    expect(rental.driver).to eq(driver)
    expect(rental.vehicle).to eq(vehicle_1)
    expect(rental.additional_driver).to eq(nil)
    expect(rental.number).to_not eq(nil)
    expect(rental.pickup).to_not eq(nil)
    expect(rental.drop_off).to_not eq(nil)
    expect(rental.pickup_odometer).to eq(40512)
    expect(rental.pickup_fuel).to eq(10)
    expect(rental.tax_rate).to eq(tax_rate)

    expect(Charge.count).to eq(1)
    charge = Charge.first
    expect(charge.owner).to eq(rental)
    expect(charge.stripe_charge_id).to_not eq(nil)

    rental.line_items.each do |l|
      expect(l.charge).to eq(charge)
    end

    stripe_charge = Stripe::Charge.retrieve(charge.stripe_charge_id)
    expect(driver.stripe_id).to eq(stripe_charge['source']['customer'])
    expect(stripe_charge['amount']).to eq(3772)
  end
end
