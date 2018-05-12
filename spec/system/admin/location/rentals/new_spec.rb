require 'spec_helper'
require 'system/admin/helpers/path_helper'
require 'system/admin/helpers/user_and_location'

require 'system/helpers/payment'

require 'factories/vehicles'
require 'factories/drivers'
require 'factories/addresses'
require 'factories/insurance_policies'
require 'factories/rates'
require 'factories/tax_rates'

describe 'create rental', type: :system, js: true do
  include_context :login_user_and_select_location

  let(:driver_stub) do
    double(:driver,
           **attributes_for(:driver),
           cell_phone_number: '1231231234',
           home_phone_number: '9098768765',
           address: build_stubbed(:address))
  end

  let(:insurance_policy_stub) { build_stubbed(:insurance_policy) }

  let(:additional_driver_stub) do
    double(:additional_driver,
           **attributes_for(:driver),
           cell_phone_number: '7601234561',
           home_phone_number: '8516781234',
           address: build_stubbed(:address))
  end

  let(:tax_rate) { create(:tax_rate, location: location) }
  let(:vehicle) { create(:vehicle, :compact, original_location: location, location: location) }

  before(:each) do
    tax_rate
    vehicle
    create(:vehicle, vehicle.vehicle_type.to_sym, original_location: location, location: location)
    create(:rate, vehicle_type: vehicle.vehicle_type, location: location, amount: 3500)
  end

  scenario 'success in creating a single driver' do
    visit_admin admin_location_rentals_new_path(slug: location.slug)

    expect(page).to have_content('Rental: Details')
    find('td', text: 'Compact').click
    click_on 'Continue'

    check_rental_rates
    click_on 'Continue'

    expect(page).to have_content('Rental: Drivers')
    fill_in_driver(driver: driver_stub, type: :driver, insurance: insurance_policy_stub)

    expect(page).to have_content('Add Additional Driver')

    click_on 'Continue'

    expect(page).to have_content('Rental: Vehicle')
    expect(page).to have_content(vehicle.license_number)
    find('td', text: vehicle.license_number).click
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

    expect(page).to have_content("#{driver_stub.name_first} #{driver_stub.name_middle} #{driver_stub.name_last}", wait: 4)

    expect(Driver.count).to eq(1)
    driver = Driver.first
    expect(driver.name_first).to              eq(driver_stub.name_first)
    expect(driver.name_middle).to             eq(driver_stub.name_middle)
    expect(driver.name_last).to               eq(driver_stub.name_last)
    expect(driver.gender).to                  eq(driver_stub.gender)
    expect(driver.date_of_birth).to           eq(driver_stub.date_of_birth)
    expect(driver.license_number).to          eq(driver_stub.license_number)
    expect(driver.license_state).to           eq(driver_stub.license_state)
    expect(driver.license_country).to         eq('United States')
    expect(driver.email).to                   eq(driver_stub.email)
    expect(driver.address_1).to               eq(nil)
    expect(driver.address_2).to               eq(nil)
    expect(driver.city).to                    eq(nil)
    expect(driver.state).to                   eq(nil)
    expect(driver.zip_code).to                eq(nil)
    expect(driver.country).to                 eq(nil)
    expect(driver.license_expiration_date).to eq(driver_stub.license_expiration_date)
    expect(driver.cell_phone_number).to       eq(nil)
    expect(driver.home_phone_number).to       eq(nil)

    expect(PhoneNumber.count).to eq(2)
    expect(driver.phone_numbers).to contain_exactly(*PhoneNumber.all)
    expect(driver.phone_numbers.cell.first.number).to eq(driver_stub.cell_phone_number)
    expect(driver.phone_numbers.home.first.number).to eq(driver_stub.home_phone_number)

    expect(Address.count).to eq(1)
    expect(driver.addresses).to contain_exactly(*Address.all)
    address = driver.addresses.first
    expect(address.street1).to  eq(driver_stub.address.street1)
    expect(address.street2).to  eq(driver_stub.address.street2)
    expect(address.city).to     eq(driver_stub.address.city)
    expect(address.state).to    eq(driver_stub.address.state)
    expect(address.zip_code).to eq(driver_stub.address.zip_code)
    expect(address.owner).to    eq(driver)

    expect(InsurancePolicy.count).to eq(1)
    insurance_policy = InsurancePolicy.first
    expect(insurance_policy.company_name).to       eq(insurance_policy_stub.company_name)
    expect(insurance_policy.agent).to              eq(insurance_policy_stub.agent)
    expect(insurance_policy.policy_number).to      eq(insurance_policy_stub.policy_number)
    expect(insurance_policy.phone_number).to       eq(insurance_policy_stub.phone_number)
    expect(insurance_policy.effective_date).to     eq(insurance_policy_stub.effective_date)
    expect(insurance_policy.expiration_date).to    eq(insurance_policy_stub.expiration_date)
    expect(insurance_policy.verify_date).to        eq(insurance_policy_stub.verify_date)
    expect(insurance_policy.verify_agent).to       eq(insurance_policy_stub.verify_agent)
    expect(insurance_policy.verify_call_center).to eq(insurance_policy_stub.verify_call_center)
    expect(insurance_policy.driver).to             eq(driver)

    expect(Rental.count).to eq(1)
    rental = Rental.first
    expect(rental.driver).to            eq(driver)
    expect(rental.vehicle).to           eq(vehicle)
    expect(rental.additional_driver).to eq(nil)
    expect(rental.number).to_not        eq(nil)
    expect(rental.pickup).to_not        eq(nil)
    expect(rental.drop_off).to_not      eq(nil)
    expect(rental.pickup_odometer).to   eq(40512)
    expect(rental.pickup_fuel).to       eq(10)
    expect(rental.drop_off_odometer).to eq(nil)
    expect(rental.drop_off_fuel).to     eq(nil)
    expect(rental.tax_rate).to          eq(tax_rate)

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

  scenario 'success in creating a additional driver' do
    visit_admin admin_location_rentals_new_path(slug: location.slug)

    expect(page).to have_content('Rental: Details')
    find('td', text: 'Compact').click
    click_on 'Continue'

    check_rental_rates
    click_on 'Continue'

    expect(page).to have_content('Rental: Drivers')
    fill_in_driver(driver: driver_stub, type: :driver, insurance: insurance_policy_stub)
    find('h3', text: 'Add Additional Driver').click
    fill_in_driver(driver: additional_driver_stub, type: :additional_driver)

    click_on 'Continue'

    expect(page).to have_content('Rental: Vehicle')
    expect(page).to have_content(vehicle.license_number)
    find('td', text: vehicle.license_number).click
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

    expect(page).to have_content("#{driver_stub.name_first} #{driver_stub.name_middle} #{driver_stub.name_last}", wait: 4)

    expect(Rental.count).to eq(1)
    rental = Rental.first
    expect(Driver.count).to eq(2)
    expect(Driver.all).to contain_exactly(rental.driver, rental.additional_driver)

    additional_driver = rental.additional_driver
    expect(additional_driver.name_first).to              eq(additional_driver_stub.name_first)
    expect(additional_driver.name_middle).to             eq(additional_driver_stub.name_middle)
    expect(additional_driver.name_last).to               eq(additional_driver_stub.name_last)
    expect(additional_driver.gender).to                  eq(additional_driver_stub.gender)
    expect(additional_driver.date_of_birth).to           eq(additional_driver_stub.date_of_birth)
    expect(additional_driver.license_number).to          eq(additional_driver_stub.license_number)
    expect(additional_driver.license_state).to           eq(additional_driver_stub.license_state)
    expect(additional_driver.license_country).to         eq('United States')
    expect(additional_driver.license_expiration_date).to eq(additional_driver_stub.license_expiration_date)
    expect(additional_driver.stripe_id).to_not           eq(nil)

    expect(additional_driver.email).to                   eq(additional_driver_stub.email)

    expect(additional_driver.address_1).to               eq(nil)
    expect(additional_driver.address_2).to               eq(nil)
    expect(additional_driver.city).to                    eq(nil)
    expect(additional_driver.state).to                   eq(nil)
    expect(additional_driver.zip_code).to                eq(nil)
    expect(additional_driver.country).to                 eq(nil)
    expect(additional_driver.home_phone_number).to eq(nil)
    expect(additional_driver.cell_phone_number).to eq(nil)

    expect(additional_driver.phone_numbers).to contain_exactly(*PhoneNumber.last(2))
    expect(additional_driver.phone_numbers.cell.first.number).to eq(additional_driver_stub.cell_phone_number)
    expect(additional_driver.phone_numbers.home.first.number).to eq(additional_driver_stub.home_phone_number)

    expect(additional_driver.addresses).to contain_exactly(Address.last)
    address = additional_driver.addresses.first
    expect(address.street1).to  eq(additional_driver_stub.address.street1)
    expect(address.street2).to  eq(additional_driver_stub.address.street2)
    expect(address.city).to     eq(additional_driver_stub.address.city)
    expect(address.state).to    eq(additional_driver_stub.address.state)
    expect(address.zip_code).to eq(additional_driver_stub.address.zip_code)
    expect(address.owner).to    eq(additional_driver)
  end

  def fill_in_driver(driver:, type:, insurance: nil)
    fill_in "#{type}_name_first",              with: driver.name_first
    fill_in "#{type}_name_middle",             with: driver.name_middle
    fill_in "#{type}_name_last",               with: driver.name_last

    fill_in "#{type}_license_number",          with: driver.license_number
    fill_in "#{type}_license_state",           with: driver.license_state
    fill_in "#{type}_license_expiration_date", with: driver.license_expiration_date.strftime('%m/%d/%Y')

    fill_in "#{type}_address_street1",         with: driver.address.street1
    fill_in "#{type}_address_street2",         with: driver.address.street2
    fill_in "#{type}_address_city",            with: driver.address.city
    fill_in "#{type}_address_state",           with: driver.address.state
    fill_in "#{type}_address_zip_code",        with: driver.address.zip_code

    fill_in "#{type}_date_of_birth",           with: driver.date_of_birth.strftime('%m/%d/%Y')
    select driver.gender.capitalize, from: "#{type}_gender"

    fill_in "#{type}_email",                   with: driver.email
    fill_in "#{type}_phone_numbers_cell",      with: driver.cell_phone_number
    fill_in "#{type}_phone_numbers_home",      with: driver.home_phone_number

    if insurance
      fill_in "#{type}_insurance_company_name",       with: insurance.company_name
      fill_in "#{type}_insurance_policy_number",      with: insurance.policy_number
      fill_in "#{type}_insurance_effective_date",     with: insurance.effective_date.strftime('%m/%d/%Y')
      fill_in "#{type}_insurance_expiration_date",    with: insurance.expiration_date.strftime('%m/%d/%Y')
      fill_in "#{type}_insurance_agent",              with: insurance.agent
      fill_in "#{type}_insurance_phone_number",       with: insurance.phone_number

      check 'Insurance Verified?'
      fill_in "#{type}_insurance_verify_agent",       with: insurance.verify_agent
      fill_in "#{type}_insurance_verify_call_center", with: insurance.verify_call_center
      fill_in "#{type}_insurance_verify_date",        with: insurance.verify_date.strftime('%m/%d/%Y')
    end
  end

  def check_rental_rates
    expect(page).to have_content('Rental: Rates')
    expect(page).to have_content('Rental Details')
    expect(page).to have_content('$200.00')
    expect(page).to have_content('Estimated Total:')
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
end
