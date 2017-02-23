class Actions::Admin::Location::Rental::Create < Lib::Forms::Base
  include Lib::Forms::Actions

  attributes do |a|
    a.date_time :pickup
    a.date_time :drop_off

    a.integer :driver_id
    a.nested :driver do |n|
      n.string  :first_name
      n.string  :last_name
      n.string  :license_number
      n.string  :license_state
      n.string  :license_country
      n.date    :license_expiration_date
      n.string  :address_1
      n.string  :address_2
      n.string  :city
      n.string  :state
      n.integer :zip_code
      n.string  :country
      n.string  :gender
      n.date    :date_of_birth
      n.string  :email
      n.integer :cell_phone_number
      n.integer :home_phone_number

      n.nested :insurance do |i|
        i.string :company_name
        i.string :policy_number
        i.string :phone_number
        i.date   :effective_date
        i.date   :expiration_date
        i.string :agent

        i.boolean :verified
        i.date    :verify_date
        i.string  :verify_agent
        i.string  :verify_call_center
      end
    end
    a.signature :financial_responsibility_signature
    a.signature :driver_signature

    a.boolean :add_additional_driver

    a.integer :additional_driver_id
    a.nested :additional_driver do |n|
      n.string  :first_name
      n.string  :last_name
      n.string  :license_number
      n.string  :license_state
      n.string  :license_country
      n.date    :license_expiration_date
      n.string  :address_1
      n.string  :address_2
      n.string  :city
      n.string  :state
      n.integer :zip_code
      n.string  :country
      n.string  :gender
      n.date    :date_of_birth
      n.string  :email
      n.integer :cell_phone_number
      n.integer :home_phone_number
    end
    a.signature :additional_driver_signature

    a.integer :vehicle_id
    a.integer :pickup_odometer
    a.integer :pickup_fuel

    a.string :promo_code

    a.string :stripe_customer_id
    a.string :card_selected
    a.string :stripe_token
  end

  validates :pickup,
    presence: true,
    after_date: -> { DateTime.today - 20.minutes }

  validates :drop_off,
    presence: true,
    after_date: { with: -> { pickup }, message: 'must be after pickup', allow_nil: true }

  validates :driver_first_name, :driver_last_name,
    presence: true

  validates :driver_license_number, :driver_license_state,
    presence: true

  validates :driver_license_country,
    presence: true

  validates :driver_license_expiration_date,
    presence: true,
    after_date: -> { drop_off }

  validates :driver_address_1, :driver_city, :driver_state, :driver_zip_code,
    presence: true

  validates :driver_country,
    presence: true

  validates :driver_gender,
    presence: true,
    inclusion: { in: %w(male female), message: "%{value} is not a valid gender" }

  validates :driver_date_of_birth,
    presence: true,
    before_date: -> { Date.today - 21.years }

  validates :driver_email,
    presence: true,
    email: true

  validates :driver_cell_phone_number, :driver_home_phone_number,
    presence: true,
    numericality: { only_integer: true },
    length: { in: 10..11 }

  validates :driver_insurance_company_name, :driver_insurance_policy_number, :driver_insurance_phone_number, :driver_insurance_agent_name,
    presence: true

  validates :driver_insurance_effective_date,
    presence: true,
    before_date: { with: -> { pickup }, allow_nil: true }

  validates :driver_insurance_expiration_date,
    presence: true,
    before_date: { with: -> { drop_off }, allow_nil: true }

  validates :driver_insurance_verified,
    acceptance: true

  validates :driver_insurance_verify_date, :driver_insurance_verify_agent, :driver_insurance_verify_call_center,
    presence: true

  with_options if: :add_additional_driver do |a|
    a.validates :additional_driver_first_name, :additional_driver_last_name,
      presence: true

    a.validates :additional_driver_license_number, :additional_driver_license_state,
      presence: true

    a.validates :additional_driver_license_country,
      presence: true

    a.validates :additional_driver_license_expiration_date,
      presence: true,
      after_date: -> { drop_off }

    a.validates :additional_driver_address_1, :additional_driver_city, :additional_driver_state, :additional_driver_zip_code,
      presence: true

    a.validates :additional_driver_country,
      presence: true

    a.validates :additional_driver_gender,
      presence: true,
      inclusion: { in: %w(male female), message: "%{value} is not a valid gender" }

    a.validates :additional_driver_date_of_birth,
      presence: true,
      before_date: -> { Date.today - 21.years }

    a.validates :additional_driver_email,
      presence: true,
      email: true

    a.validates :additional_driver_cell_phone_number, :additional_driver_home_phone_number,
      presence: true,
      numericality: { only_integer: true },
      length: { in: 10..11 }
  end

  validates :financial_responsibility_signature, :driver_signature, :additional_driver_signature,
    presence: true

  validates :pickup_odometer,
    presence: true,
    numericality: { only_integer: true }

  validates :pickup_fuel,
    presence: true,
    inclusion: { in: 0..10 }

  def valid?
    valid = super

    if valid
      success = lambda do |args|
        @charge = args.fetch(:charge)
        write_attribute(:stripe_customer_id, args.fetch(:customer_id))
        return true
      end

      failure = lambda do |args|
        write_attribute(:stripe_customer_id, args.fetch(:customer_id))
        return false
      end

      charge = Charge.new()
      charge.execute(success, failure, create_customer: stripe_customer_id.blank?, token: stripe_token, customer_id: stripe_customer_id)
    end
  end

  def save
    driver = Driver.create(driver.except(:insurance))
    InsurancePolicy.create(driver.fetch(:insurance).merge(:driver => driver))

    if add_additional_driver
      additional_driver = AdditionalDriver.create(additional_driver)
    end

    rental = Rental.create_open({
      :driver                             => driver,
      :additional_driver                  => (additional_driver if add_additional_driver),
      :vehicle_id                         => vehicle_id,
      :vehicle_type                       => vehicle_type,
      :notes                              => notes,
      :pickup_location                    => Location.first,
      :pickup                             => pickup,
      :pickup_odometer                    => pickup_odometer,
      :pickup_fuel                        => pickup_fuel,
      :drop_off_location                  => Location.first,
      :drop_off                           => drop_off,
      :collision_damage_waiver            => false,
      :financial_responsibility_signature => financial_responsibility_signature,
      :driver_signature                   => driver_signature,
      :additional_driver_signature        => additional_driver_signature,
    })

    charge.owner = rental
    charge.save
  end

  def vehicle_type
    'compact'
  end
end
