require 'spec_helper'
require 'factories/locations'
require 'factories/vehicles'
require 'factories/drivers'
require 'factories/users'
require 'factories/rates'
require 'factories/tax_rates'
require 'factories/insurance_policies'
require 'helpers/stripe_helper'

describe Actions::Admin::Location::Rental::New::Create do

  describe '#save' do
    it 'saves driver, insurance policy, rental' do
      user = create(:user)
      location = create(:location)
      tax_rate = create(:tax_rate, location: location)
      vehicle = create(:vehicle, original_location: location, location: location)

      create(:rate, vehicle_type: 'mid_size', location: location, amount: 3500)

      driver_attrs = attributes_for(:driver)
      driver_attrs[:insurance] = attributes_for(:insurance_policy)

      success = double(:success)
      failure = double(:failure)

      expect(success).to receive(:call)

      drop_off = DateTime.now + 2.days

      Actions::Admin::Location::Rental::New::Create.new({
        :drop_off                                  => drop_off,
        :driver                                    => driver_attrs,
        :driver_signature                          => 'test',
        :driver_financial_responsibility_signature => 'test',
        :add_additional_driver                     => false,
        :vehicle_type                              => vehicle.vehicle_type,
        :vehicle_id                                => vehicle.id,
        :pickup_odometer                           => 1250,
        :pickup_fuel                               => 10,
        :stripe_token                              => create_valid_credit_card_token_id,
        :paid_by                                   => :driver,
      }).execute(success, failure, { :user_id => user.id, :location_id => location.id })

      expect(Driver.count).to eq(1)
      driver = Driver.first
      expect(driver.name_first).to eq(driver_attrs[:name_first])
      expect(driver.name_middle).to eq(driver_attrs[:name_middle])
      expect(driver.name_last).to eq(driver_attrs[:name_last])
      expect(driver.gender).to eq(driver_attrs[:gender])
      expect(driver.address_1).to eq(driver_attrs[:address_1])
      expect(driver.address_2).to eq(driver_attrs[:address_2])
      expect(driver.city).to eq(driver_attrs[:city])
      expect(driver.state).to eq(driver_attrs[:state])
      expect(driver.zip_code).to eq(driver_attrs[:zip_code])
      expect(driver.country).to eq(driver_attrs[:country])
      expect(driver.home_phone_number).to eq(driver_attrs[:home_phone_number])
      expect(driver.cell_phone_number).to eq(driver_attrs[:cell_phone_number])
      expect(driver.email).to eq(driver_attrs[:email])
      expect(driver.date_of_birth).to eq(driver_attrs[:date_of_birth])
      expect(driver.license_number).to eq(driver_attrs[:license_number])
      expect(driver.license_state).to eq(driver_attrs[:license_state])
      expect(driver.license_country).to eq(driver_attrs[:license_country])
      expect(driver.license_expiration_date).to eq(driver_attrs[:license_expiration_date])
      expect(driver.stripe_id).to_not eq(nil)

      expect(InsurancePolicy.count).to eq(1)
      insurance_policy = InsurancePolicy.first
      expect(insurance_policy.company_name).to eq(driver_attrs[:insurance][:company_name])
      expect(insurance_policy.agent).to eq(driver_attrs[:insurance][:agent])
      expect(insurance_policy.policy_number).to eq(driver_attrs[:insurance][:policy_number])
      expect(insurance_policy.phone_number).to eq(driver_attrs[:insurance][:phone_number])
      expect(insurance_policy.effective_date).to eq(driver_attrs[:insurance][:effective_date])
      expect(insurance_policy.expiration_date).to eq(driver_attrs[:insurance][:expiration_date])
      expect(insurance_policy.verify_date).to eq(driver_attrs[:insurance][:verify_date])
      expect(insurance_policy.verify_agent).to eq(driver_attrs[:insurance][:verify_agent])
      expect(insurance_policy.verify_call_center).to eq(driver_attrs[:insurance][:verify_call_center])
      expect(insurance_policy.driver).to eq(driver)

      expect(Rental.count).to eq(1)
      rental = Rental.first
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

      expect(LineItem.count).to eq(2)
      expect(rental.line_items.count).to eq(2)
      rental.line_items.each do |l|
        expect(l.item_type).to eq('rental_rate')
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
      user = create(:user)
      location = create(:location)
      create(:tax_rate, location: location)
      vehicle = create(:vehicle, original_location: location, location: location)

      create(:rate, vehicle_type: 'mid_size', location: location, amount: 3500)

      driver_attrs = attributes_for(:driver)
      driver_attrs[:insurance] = attributes_for(:insurance_policy)
      additional_driver_attrs = attributes_for(:driver)

      success = double(:success)
      failure = double(:failure)

      expect(success).to receive(:call)

      drop_off = DateTime.now + 2.days

      Actions::Admin::Location::Rental::New::Create.new({
        :drop_off                                             => drop_off,
        :driver                                               => driver_attrs,
        :add_additional_driver                                => true,
        :additional_driver                                    => additional_driver_attrs,
        :driver_signature                                     => 'test',
        :driver_financial_responsibility_signature            => 'test',
        :additional_driver_signature                          => 'test',
        :additional_driver_financial_responsibility_signature => 'test',
        :vehicle_type                                         => vehicle.vehicle_type,
        :vehicle_id                                           => vehicle.id,
        :pickup_odometer                                      => 1250,
        :pickup_fuel                                          => 10,
        :stripe_token                                         => create_valid_credit_card_token_id,
        :paid_by                                              => :driver,
      }).execute(success, failure, { :user_id => user.id, :location_id => location.id })

      expect(Driver.count).to eq(2)
      driver = Driver.first
      expect(driver.stripe_id).to_not eq(nil)

      additional_driver = Driver.last
      expect(additional_driver.name_first).to eq(additional_driver_attrs[:name_first])
      expect(additional_driver.name_middle).to eq(additional_driver_attrs[:name_middle])
      expect(additional_driver.name_last).to eq(additional_driver_attrs[:name_last])
      expect(additional_driver.gender).to eq(additional_driver_attrs[:gender])
      expect(additional_driver.address_1).to eq(additional_driver_attrs[:address_1])
      expect(additional_driver.address_2).to eq(additional_driver_attrs[:address_2])
      expect(additional_driver.city).to eq(additional_driver_attrs[:city])
      expect(additional_driver.state).to eq(additional_driver_attrs[:state])
      expect(additional_driver.zip_code).to eq(additional_driver_attrs[:zip_code])
      expect(additional_driver.country).to eq(additional_driver_attrs[:country])
      expect(additional_driver.home_phone_number).to eq(additional_driver_attrs[:home_phone_number])
      expect(additional_driver.cell_phone_number).to eq(additional_driver_attrs[:cell_phone_number])
      expect(additional_driver.email).to eq(additional_driver_attrs[:email])
      expect(additional_driver.date_of_birth).to eq(additional_driver_attrs[:date_of_birth])
      expect(additional_driver.license_number).to eq(additional_driver_attrs[:license_number])
      expect(additional_driver.license_state).to eq(additional_driver_attrs[:license_state])
      expect(additional_driver.license_country).to eq(additional_driver_attrs[:license_country])
      expect(additional_driver.license_expiration_date).to eq(additional_driver_attrs[:license_expiration_date])
      expect(additional_driver.stripe_id).to eq(nil)

      expect(Rental.count).to eq(1)
      rental = Rental.first
      expect(rental.driver).to eq(driver)
      expect(rental.additional_driver).to eq(additional_driver)
    end

    it 'paid for by additional driver' do
      user = create(:user)
      location = create(:location)
      create(:tax_rate, location: location)
      vehicle = create(:vehicle, original_location: location, location: location)

      create(:rate, vehicle_type: 'mid_size', location: location, amount: 3500)

      driver_attrs = attributes_for(:driver)
      driver_attrs[:insurance] = attributes_for(:insurance_policy)
      additional_driver_attrs = attributes_for(:driver)

      success = double(:success)
      failure = double(:failure)

      expect(success).to receive(:call)

      drop_off = DateTime.now + 2.days

      Actions::Admin::Location::Rental::New::Create.new({
        :drop_off                                             => drop_off,
        :driver                                               => driver_attrs,
        :add_additional_driver                                => true,
        :additional_driver                                    => additional_driver_attrs,
        :driver_signature                                     => 'test',
        :driver_financial_responsibility_signature            => 'test',
        :additional_driver_signature                          => 'test',
        :additional_driver_financial_responsibility_signature => 'test',
        :vehicle_type                                         => vehicle.vehicle_type,
        :vehicle_id                                           => vehicle.id,
        :pickup_odometer                                      => 1250,
        :pickup_fuel                                          => 10,
        :stripe_token                                         => create_valid_credit_card_token_id,
        :paid_by                                              => :additional_driver,
      }).execute(success, failure, { :user_id => user.id, :location_id => location.id })

      driver = Driver.first
      expect(driver.stripe_id).to eq(nil)

      additional_driver = Driver.last
      expect(additional_driver.stripe_id).to_not eq(nil)
    end
  end
end
