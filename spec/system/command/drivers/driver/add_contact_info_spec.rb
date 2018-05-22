require 'spec_helper'
require 'system/command/helpers/path_helper'
require 'system/command/helpers/user'

require 'factories/drivers'
require 'factories/addresses'
require 'factories/emails'
require 'factories/phone_numbers'

describe 'Add Contact Info', type: :system, js: true do
  include_context :login_user

  scenario 'success' do
    driver = create(:driver)

    email_stub   = build(:email)
    address_stub = build(:address, address_type: :home)
    number_stub  = build(:phone_number)

    expect(Address.count).to eq(0)
    expect(Email.count).to eq(0)
    expect(PhoneNumber.count).to eq(0)

    visit_command command_driver_path(id: driver.id)

    expect(page).to have_content(driver.name)
    find("a[data-toggle='dropdown']").click
    click_button('Add Contact Info')

    expect(page).to have_content('Add Contact Info')

    within('div.popup') do
      check('Email')
      fill_in 'email_email', with: email_stub.email

      check('Address')
      select address_stub.address_type.capitalize, from: 'address_address_type'
      fill_in 'address_street1',  with: address_stub.street1
      fill_in 'address_street2',  with: address_stub.street2
      fill_in 'address_city',     with: address_stub.city
      fill_in 'address_state',    with: address_stub.state
      fill_in 'address_zip_code', with: address_stub.zip_code

      check('Phone Number')
      fill_in 'phone_number_number', with: number_stub.number

      click_button('Add')
    end
    expect(page).to_not have_content('Add Contact Info')

    driver = Driver.first

    emails = Email.all
    expect(emails.count).to eq(1)
    expect(driver.emails).to contain_exactly(*emails)
    email = emails.first
    expect(email.email).to eq(email_stub.email)

    addresses = Address.all
    expect(addresses.count).to eq(1)
    expect(driver.addresses).to contain_exactly(*addresses)
    address = addresses.first
    expect(address.street1).to eq(address_stub.street1)
    expect(address.street2).to eq(address_stub.street2)
    expect(address.city).to eq(address_stub.city)
    expect(address.state).to eq(address_stub.state)
    expect(address.zip_code).to eq(address_stub.zip_code)

    phone_numbers = PhoneNumber.all
    expect(phone_numbers.count).to eq(1)
    expect(driver.phone_numbers).to contain_exactly(*phone_numbers)
    phone_number = phone_numbers.first
    expect(phone_number.number).to eq(number_stub.number)
  end
end
