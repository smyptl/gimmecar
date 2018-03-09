require 'spec_helper'
require 'system/admin/helpers/path_helper'
require 'system/admin/helpers/user_and_location'

require 'helpers/stripe_helper'

require 'factories/vehicles'
require 'factories/drivers'
require 'factories/insurance_policies'
require 'factories/rates'
require 'factories/tax_rates'

def fill_in_driver(driver:, insurance: nil)
  fill_in 'driver_name_first',              with: driver.name_first
  fill_in 'driver_name_middle',             with: driver.name_middle
  fill_in 'driver_name_last',               with: driver.name_last

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

  fill_in 'driver_date_of_birth',           with: driver.date_of_birth.strftime('%m/%d/%Y')
  select driver.gender.capitalize, from: 'driver_gender'

  fill_in 'driver_email',                   with: driver.email
  fill_in 'driver_cell_phone_number',       with: driver.cell_phone_number
  fill_in 'driver_home_phone_number',       with: driver.home_phone_number

  if insurance
    fill_in 'driver_insurance_company_name',       with: insurance.company_name
    fill_in 'driver_insurance_policy_number',      with: insurance.policy_number
    fill_in 'driver_insurance_effective_date',     with: insurance.effective_date.strftime('%m/%d/%Y')
    fill_in 'driver_insurance_expiration_date',    with: insurance.expiration_date.strftime('%m/%d/%Y')
    fill_in 'driver_insurance_agent',              with: insurance.agent
    fill_in 'driver_insurance_phone_number',       with: insurance.phone_number

    check 'Insurance Verified?'
    fill_in 'driver_insurance_verify_agent',       with: insurance.verify_agent
    fill_in 'driver_insurance_verify_call_center', with: insurance.verify_call_center
    fill_in 'driver_insurance_verify_date',        with: insurance.verify_date.strftime('%m/%d/%Y')
  end
end

def check_financial_responsibility(driver:, additional_driver: nil)
  expect(page).to have_content('Rental: Financial Responsibility')
  expect(page).to have_content('Notice About Your Financial Responibility')
  expect(page).to have_content("#{driver.name_first} #{driver.name_last}")

  if additional_driver
    expect(page).to have_content("#{additional_driver.name_first} #{additional_driver.name_last}")
  end
end

def check_rental_terms(driver:, additional_driver: nil)
  expect(page).to have_content('Rental: Terms & Conditions')
  expect(page).to have_content('Total:')
  expect(page).to have_content('Rental Agreement Terms and Conditions')
  expect(page).to have_content("#{driver.name_first} #{driver.name_last}")

  if additional_driver
    expect(page).to have_content("#{additional_driver.name_first} #{additional_driver.name_last}")
  end
end

def fill_in_payment(number: CARD_TYPE[:visa], expiration_date: '01/20', cvc: '123', zip_code: '90210')
  stripe_iframe = all('iframe[name=__privateStripeFrame3]').last
  Capybara.within_frame stripe_iframe do
    find('input[name=cardnumber]').set(number)
    find('input[name="exp-date"]').set(expiration_date)
    find('input[name="cvc"]').set(cvc)
    find('input[name="postal"]').set(zip_code)
  end
end

describe 'create rental', type: :system, js: true do
  include_context :login_user_and_select_location

  scenario 'success in creating a single driver' do
    tax_rate = create(:tax_rate, location: location)
    vehicle_1 = create(:vehicle, vehicle_type: :mid_size, original_location: location, location: location)
    create(:vehicle, vehicle_type: :mid_size, original_location: location, location: location)

    create(:rate, vehicle_type: vehicle_1.vehicle_type, location: location, amount: 3500)

    visit_admin admin_location_rentals_new_path(slug: location.slug)

    expect(page).to have_content('Rental: Details')
    select 'Mid-Size', from: 'vehicle_type'
    click_on 'Continue'

    expect(page).to have_content('Rental: Rates')
    expect(page).to have_content('Rental Details')
    expect(page).to have_content('Estimated Total:')
    click_on 'Continue'

    expect(page).to have_content('Rental: Drivers')
    driver_stub = build_stubbed(:driver)
    driver_insurance_stub = build_stubbed(:insurance_policy)
    fill_in_driver(driver: driver_stub, insurance: driver_insurance_stub)

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

    check_financial_responsibility(driver: driver_stub)
    click_on 'Continue'

    check_rental_terms(driver: driver_stub)
    click_on 'Continue'

    expect(page).to have_content('Rental: Payment')

    fill_in_payment
    click_on 'Continue'

    expect(page).to have_content("#{driver_stub.name_first} #{driver_stub.name_middle} #{driver_stub.name_last}", wait: 5)

    expect(Driver.count).to eq(1)
    driver = Driver.first
    expect(driver.name_first).to eq(driver_stub.name_first)
    expect(driver.name_middle).to eq(driver_stub.name_middle)
    expect(driver.name_last).to eq(driver_stub.name_last)
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
    expect(stripe_charge['amount']).to eq(charge.amount)
  end

  scenario 'credit card fails' do
    create(:tax_rate, location: location)
    vehicle_1 = create(:vehicle, vehicle_type: :compact, original_location: location, location: location)

    create(:rate, vehicle_type: :compact, location: location, amount: 3500)

    visit_admin admin_location_rentals_new_path(slug: location.slug)

    expect(page).to have_content('Rental: Details')
    select 'Compact', from: 'Vehicle Type'
    click_on 'Continue'

    expect(page).to have_content('Rental: Rates')
    expect(page).to have_content('Rental Details')
    expect(page).to have_content('$200.00')
    expect(page).to have_content('Estimated Total:')
    click_on 'Continue'

    expect(page).to have_content('Rental: Drivers')
    driver_stub = build_stubbed(:driver)
    driver_insurance_stub = build_stubbed(:insurance_policy)
    fill_in_driver(driver: driver_stub, insurance: driver_insurance_stub)

    click_on 'Continue'

    expect(page).to have_content('Rental: Vehicle')
    expect(page).to have_content(vehicle_1.license_number)
    find('td', text: vehicle_1.license_number).click
    fill_in 'Vehicle Odometer', with: 40512
    expect(page).to have_content('100%')
    click_on 'Continue'

    #expect(page).to have_content('Rental: Add-Ons')
    #click_on 'Continue'

    check_financial_responsibility(driver: driver_stub)
    click_on 'Continue'

    check_rental_terms(driver: driver_stub)
    click_on 'Continue'

    expect(page).to have_content('Rental: Payment')

    fill_in_payment(number: INVALID_CREDIT_CARD_REASONS[:zip_code], expiration_date: '01/10')
    click_on 'Continue'

    expect(page).to have_content("Your card's expiration year is in the past.")

    fill_in_payment(number: INVALID_CREDIT_CARD_REASONS[:zip_code])
    click_on 'Continue'
    expect(page).to_not have_content("Your card's expiration year is in the past.")
    expect(page).to have_content("The zip code you supplied failed validation.")

    fill_in_payment
    click_on 'Continue'

    expect(page).to have_content("#{driver_stub.name_first} #{driver_stub.name_middle} #{driver_stub.name_last}", wait: 10)
  end

  scenario 'success in creating a additional driver' do
    create(:tax_rate, location: location)
    vehicle_1 = create(:vehicle, vehicle_type: 'compact', original_location: location, location: location)

    create(:rate, vehicle_type: vehicle_1.vehicle_type, location: location, amount: 3500)

    visit_admin admin_location_rentals_new_path(slug: location.slug)

    expect(page).to have_content('Rental: Details')
    select 'Compact', from: 'Vehicle Type'
    click_on 'Continue'

    expect(page).to have_content('Rental: Rates')
    expect(page).to have_content('Rental Details')
    expect(page).to have_content('Estimated Total:')
    click_on 'Continue'

    expect(page).to have_content('Rental: Drivers')
    driver_stub = build_stubbed(:driver)
    driver_insurance_stub = build_stubbed(:insurance_policy)
    fill_in_driver(driver: driver_stub, insurance: driver_insurance_stub)

    additional_driver_stub = build_stubbed(:driver)

    find('h3', text: 'Add Additional Driver').click

    fill_in 'additional_driver_name_first',              with: additional_driver_stub.name_first
    fill_in 'additional_driver_name_middle',             with: additional_driver_stub.name_middle
    fill_in 'additional_driver_name_last',               with: additional_driver_stub.name_last

    fill_in 'additional_driver_license_number',          with: additional_driver_stub.license_number
    fill_in 'additional_driver_license_state',           with: additional_driver_stub.license_state
    fill_in 'additional_driver_license_country',         with: additional_driver_stub.license_country
    fill_in 'additional_driver_license_expiration_date', with: additional_driver_stub.license_expiration_date.strftime('%m/%d/%Y')

    fill_in 'additional_driver_address_1',               with: additional_driver_stub.address_1
    fill_in 'additional_driver_address_2',               with: additional_driver_stub.address_2
    fill_in 'additional_driver_city',                    with: additional_driver_stub.city
    fill_in 'additional_driver_state',                   with: additional_driver_stub.state
    fill_in 'additional_driver_zip_code',                with: additional_driver_stub.zip_code
    fill_in 'additional_driver_country',                 with: additional_driver_stub.country

    fill_in 'additional_driver_date_of_birth',           with: additional_driver_stub.date_of_birth.strftime('%m/%d/%Y')
    select additional_driver_stub.gender.capitalize, from: 'additional_driver_gender'

    fill_in 'additional_driver_email',                   with: additional_driver_stub.email
    fill_in 'additional_driver_cell_phone_number',       with: additional_driver_stub.cell_phone_number
    fill_in 'additional_driver_home_phone_number',       with: additional_driver_stub.home_phone_number

    click_on 'Continue'

    expect(page).to have_content('Rental: Vehicle')
    expect(page).to have_content(vehicle_1.license_number)
    find('td', text: vehicle_1.license_number).click
    fill_in 'Vehicle Odometer', with: 40512
    expect(page).to have_content('100%')
    click_on 'Continue'

    #expect(page).to have_content('Rental: Add-Ons')
    #click_on 'Continue'

    check_financial_responsibility(driver: driver_stub, additional_driver: additional_driver_stub)
    click_on 'Continue'

    check_rental_terms(driver: driver_stub, additional_driver: additional_driver_stub)
    click_on 'Continue'

    expect(page).to have_content('Rental: Payment')
    select "#{additional_driver_stub.name_first} #{additional_driver_stub.name_last}"

    fill_in_payment
    click_on 'Continue'

    expect(page).to have_content("#{driver_stub.name_first} #{driver_stub.name_middle} #{driver_stub.name_last}", wait: 5)

    expect(Driver.count).to eq(2)
    driver = Driver.first

    additional_driver = Driver.last
    expect(additional_driver.name_first).to eq(additional_driver_stub.name_first)
    expect(additional_driver.name_middle).to eq(additional_driver_stub.name_middle)
    expect(additional_driver.name_last).to eq(additional_driver_stub.name_last)
    expect(additional_driver.gender).to eq(additional_driver_stub.gender)
    expect(additional_driver.address_1).to eq(additional_driver_stub.address_1)
    expect(additional_driver.address_2).to eq(additional_driver_stub.address_2)
    expect(additional_driver.city).to eq(additional_driver_stub.city)
    expect(additional_driver.state).to eq(additional_driver_stub.state)
    expect(additional_driver.zip_code).to eq(additional_driver_stub.zip_code)
    expect(additional_driver.country).to eq(additional_driver_stub.country)
    expect(additional_driver.home_phone_number).to eq(additional_driver_stub.home_phone_number)
    expect(additional_driver.cell_phone_number).to eq(additional_driver_stub.cell_phone_number)
    expect(additional_driver.email).to eq(additional_driver_stub.email)
    expect(additional_driver.date_of_birth).to eq(additional_driver_stub.date_of_birth)
    expect(additional_driver.license_number).to eq(additional_driver_stub.license_number)
    expect(additional_driver.license_state).to eq(additional_driver_stub.license_state)
    expect(additional_driver.license_country).to eq(additional_driver_stub.license_country)
    expect(additional_driver.license_expiration_date).to eq(additional_driver_stub.license_expiration_date)
    expect(additional_driver.stripe_id).to_not eq(nil)

    expect(Rental.count).to eq(1)
    rental = Rental.first
    expect(rental.driver).to eq(driver)
    expect(rental.additional_driver).to eq(additional_driver)
  end
end
