require 'spec_helper'
require 'factories/locations'
require 'factories/vehicles'
require 'factories/drivers'
require 'factories/addresses'
require 'factories/users'
require 'factories/rates'
require 'factories/tax_rates'
require 'factories/insurance_policies'
require 'helpers/stripe_helper'

describe Actions::Admin::Location::Rental::New::Create do

  let(:user)     { create(:user) }
  let(:location) { create(:location) }
  let(:tax_rate) { create(:tax_rate, location: location) }
  let(:vehicle)  { create(:vehicle, :compact, original_location: location, location: location) }
  let(:rate)     { create(:rate, vehicle_type: vehicle.vehicle_type, location: location, amount: 3500) }

  before(:each) { tax_rate; rate; }

  let(:success) { double(:success) }
  let(:failure) { double(:failure) }

  let(:driver_attrs) do
    driver_attrs = attributes_for(:driver)
    driver_attrs[:insurance] = attributes_for(:insurance_policy)
    driver_attrs[:phone_numbers] = { cell: '9091231234', home: '' }
    driver_attrs[:address] = attributes_for(:address).except(:address_type)
    driver_attrs
  end

  let(:additional_driver_attrs) do
    driver_attrs.except(:insurance)
  end

  let(:drop_off) { Time.current + 2.days }

  before(:each) do
    expect(Rental.count).to eq(0)
    expect(Driver.count).to eq(0)
  end

  describe '#save' do
    it 'saves driver, insurance policy, rental' do
      expect(success).to receive(:call)

      Actions::Admin::Location::Rental::New::Create.new({
        drop_off:                                  drop_off,
        driver:                                    driver_attrs,
        driver_signature:                          'test',
        driver_financial_responsibility_signature: 'test',
        add_additional_driver:                     false,
        vehicle_type:                              vehicle.vehicle_type,
        vehicle_id:                                vehicle.id,
        pickup_odometer:                           1250,
        pickup_fuel:                               10,
        stripe_token:                              create_valid_credit_card_token_id,
        paid_by:                                   :driver,
      }).execute(success, failure, user_id: user.id, location_id: location.id)

      expect(Driver.count).to eq(1)
      driver = Driver.first
      expect(driver.name_first).to eq(driver_attrs[:name_first])
      expect(driver.name_middle).to eq(driver_attrs[:name_middle])
      expect(driver.name_last).to eq(driver_attrs[:name_last])
      expect(driver.gender).to eq(driver_attrs[:gender])
      expect(driver.email).to eq(driver_attrs[:email])
      expect(driver.date_of_birth).to eq(driver_attrs[:date_of_birth])
      expect(driver.license_number).to eq(driver_attrs[:license_number])
      expect(driver.license_state).to eq(driver_attrs[:license_state])
      expect(driver.license_country).to eq(driver_attrs[:license_country])
      expect(driver.license_expiration_date).to eq(driver_attrs[:license_expiration_date])
      expect(driver.stripe_id).to_not eq(nil)
      expect(driver.phone_numbers.count).to eq(1)
      expect(driver.addresses.count).to eq(1)

      expect(PhoneNumber.count).to eq(1)
      PhoneNumber.all.each do |phone_number|
        expect(phone_number.owner).to eq(driver)
        expect(phone_number.phone_type).to eq('cell')
        expect(phone_number.number).to eq(driver_attrs[:phone_numbers][:cell])
      end

      expect(Address.count).to eq(1)
      Address.all.each do |address|
        expect(address.attributes).to include(driver_attrs[:address].stringify_keys)
        expect(address.owner).to eq(driver)
      end

      expect(InsurancePolicy.count).to eq(1)
      insurance_policy = InsurancePolicy.first
      expect(insurance_policy.attributes).to include(driver_attrs[:insurance].stringify_keys)
      expect(insurance_policy.driver).to eq(driver)

      expect(Rental.count).to eq(1)
      rental = Rental.first
      expect(rental.driver).to eq(driver)
      expect(rental.additional_driver).to eq(nil)
      expect(rental.status).to eq('open')
      expect(rental.number).to_not eq(nil)
      expect(rental.driver).to eq(driver)
      expect(rental.vehicle).to eq(vehicle)
      expect(rental.additional_driver).to eq(nil)
      expect(rental.tax_rate).to eq(tax_rate)
      expect(rental.pickup).to_not eq(nil)
      expect(rental.pickup_location).to eq(location)
      expect(rental.drop_off).to eq(drop_off)
      expect(rental.drop_off_location).to eq(location)
      expect(rental.drop_off_odometer).to eq(nil)
      expect(rental.drop_off_fuel).to eq(nil)
      expect(rental.pickup_odometer).to eq(1250)
      expect(rental.pickup_fuel).to eq(10)

      expect(Charge.count).to eq(1)
      charge = Charge.first
      expect(charge.owner).to eq(rental)
      expect(charge.stripe_charge_id).to_not eq(nil)

      expect(LineItem.count).to eq(3)
      expect(rental.line_items.rental_rates.count).to eq(2)
      expect(rental.line_items.deposits.count).to eq(1)

      rental.line_items.each do |l|
        expect(l.invoice).to eq(rental)
        expect(l.charge).to eq(charge)
        expect(l.amount).to_not eq(nil)
        expect(l.total).to_not eq(nil)
      end

      stripe_charge = Stripe::Charge.retrieve(charge.stripe_charge_id)
      expect(driver.stripe_id).to eq(stripe_charge['source']['customer'])
      expect(stripe_charge['amount']).to eq(charge.amount)
    end

    it 'saves additional driver' do
      expect(success).to receive(:call)

      Actions::Admin::Location::Rental::New::Create.new({
        drop_off:                                             drop_off,
        driver:                                               driver_attrs,
        add_additional_driver:                                true,
        additional_driver:                                    additional_driver_attrs,
        driver_signature:                                     'test',
        driver_financial_responsibility_signature:            'test',
        additional_driver_signature:                          'test',
        additional_driver_financial_responsibility_signature: 'test',
        vehicle_type:                                         vehicle.vehicle_type,
        vehicle_id:                                           vehicle.id,
        pickup_odometer:                                      1250,
        pickup_fuel:                                          10,
        stripe_token:                                         create_valid_credit_card_token_id,
        paid_by:                                              :driver,
      }).execute(success, failure, user_id: user.id, location_id: location.id)

      expect(Rental.count).to eq(1)
      expect(Driver.count).to eq(2)
      rental = Rental.first
      expect(Driver.all).to contain_exactly(rental.driver, rental.additional_driver)
      expect(rental.driver.stripe_id).to_not eq(nil)

      additional_driver = rental.additional_driver
      expect(additional_driver.name_first).to eq(additional_driver_attrs[:name_first])
      expect(additional_driver.name_middle).to eq(additional_driver_attrs[:name_middle])
      expect(additional_driver.name_last).to eq(additional_driver_attrs[:name_last])
      expect(additional_driver.gender).to eq(additional_driver_attrs[:gender])
      expect(additional_driver.email).to eq(additional_driver_attrs[:email])
      expect(additional_driver.date_of_birth).to eq(additional_driver_attrs[:date_of_birth])
      expect(additional_driver.license_number).to eq(additional_driver_attrs[:license_number])
      expect(additional_driver.license_state).to eq(additional_driver_attrs[:license_state])
      expect(additional_driver.license_country).to eq(additional_driver_attrs[:license_country])
      expect(additional_driver.license_expiration_date).to eq(additional_driver_attrs[:license_expiration_date])
      expect(additional_driver.stripe_id).to eq(nil)
      expect(additional_driver.phone_numbers.count).to eq(1)
      expect(additional_driver.addresses.count).to eq(1)

      additional_driver.phone_numbers.all.each do |phone_number|
        expect(phone_number.owner).to eq(additional_driver)
        expect(phone_number.phone_type).to eq('cell')
        expect(phone_number.number).to eq(additional_driver_attrs[:phone_numbers][:cell])
      end

      additional_driver.addresses.each do |address|
        expect(address.attributes).to include(additional_driver_attrs[:address].stringify_keys)
        expect(address.owner).to eq(additional_driver)
      end
    end

    it 'paid for by additional driver' do
      expect(success).to receive(:call)

      Actions::Admin::Location::Rental::New::Create.new({
        drop_off:                                             drop_off,
        driver:                                               driver_attrs,
        add_additional_driver:                                true,
        additional_driver:                                    additional_driver_attrs,
        driver_signature:                                     'test',
        driver_financial_responsibility_signature:            'test',
        additional_driver_signature:                          'test',
        additional_driver_financial_responsibility_signature: 'test',
        vehicle_type:                                         vehicle.vehicle_type,
        vehicle_id:                                           vehicle.id,
        pickup_odometer:                                      1250,
        pickup_fuel:                                          10,
        stripe_token:                                         create_valid_credit_card_token_id,
        paid_by:                                              :additional_driver,
      }).execute(success, failure, user_id: user.id, location_id: location.id)

      rental = Rental.first
      expect(rental.driver.stripe_id).to eq(nil)
      expect(rental.additional_driver.stripe_id).to_not eq(nil)
    end
  end
end
