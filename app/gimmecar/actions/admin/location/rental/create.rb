class Actions::Admin::Location::Rental::Create < Lib::Forms::Base
  include Actions::Admin::Location::Rental::Concerns::Driver

  attributes do |a|
    a.date_time :drop_off

    a.signature :driver_financial_responsibility_signature
    a.signature :driver_signature

    a.signature :additional_driver_signature
    a.signature :additional_driver_financial_responsibility_signature

    a.string  :vehicle_type
    a.integer :vehicle_id
    a.integer :pickup_odometer
    a.integer :pickup_fuel

    a.string :promo_code

    a.string :stripe_customer_id
    a.string :stripe_token
  end

  validates :drop_off,
    presence: true,
    after_date: { with: -> { pickup }, message: 'must be after pickup', allow_nil: true }

  validates :driver_financial_responsibility_signature, :driver_signature,
    signature: true

  with_options if: :add_additional_driver do |a|
    a.validates :additional_driver_financial_responsibility_signature, :additional_driver_signature,
      signature: true
  end

  validates :vehicle_type,
    presence: true

  validates :vehicle_id,
    inclusion: { in: :available_vehicle_ids, message: 'select a vehicle' }

  validates :pickup_odometer,
    presence: true,
    numericality: { only_integer: true }

  validates :pickup_fuel,
    presence: true,
    inclusion: { in: 0..10 }

  def pickup
    DateTime.now
  end

  def rental_period
    return unless pickup && drop_off
    return unless pickup.before?(drop_off)
    @rental_period ||= Lib::DateRange.new(pickup, drop_off)
  end

  def rates
    @rates ||= Services::Rates.fetch(rental: self, location: location)
  end

  def location
    @location ||= Location.find(params.fetch(:location_id))
  end

  def available_vehicle_ids
    location.available_vehicle_ids(vehicle_type: vehicle_type, date_range: rental_period)
  end

  def valid?
    valid = super

    if valid
      success = lambda do |args|
        @charge = args.fetch(:charge)
        write_attribute(:stripe_customer_id, args.fetch(:customer_id))
        return true
      end

      failure = lambda do |args|
        errors.add(:card, args.fetch(:message))
        write_attribute(:stripe_customer_id, args.fetch(:customer_id))
        return false
      end

      Charge.new({ :amount => rates.fetch(:total) }).execute(success, failure, token: stripe_token, customer_id: stripe_customer_id)
    end
  end

  def save
    d = Driver.create(driver.except(:insurance).merge(:stripe_id => stripe_customer_id))
    InsurancePolicy.create(driver.fetch(:insurance).except(:verified).merge(:driver => d, :user_id => params.fetch(:user_id)))

    ad = AdditionalDriver.create(additional_driver) if add_additional_driver

    @rental = Rental.create_open({
      :driver                                               => d,
      :additional_driver                                    => (ad if add_additional_driver),
      :vehicle_id                                           => vehicle_id,
      :vehicle_type                                         => vehicle_type,
      :tax_rate                                             => location.latest_tax_rate,
      :pickup_location                                      => location,
      :pickup                                               => pickup,
      :pickup_odometer                                      => pickup_odometer,
      :pickup_fuel                                          => pickup_fuel,
      :drop_off_location                                    => location,
      :drop_off                                             => drop_off,
      :collision_damage_waiver                              => false,
      :driver_financial_responsibility_signature            => driver_financial_responsibility_signature,
      :additional_driver_financial_responsibility_signature => additional_driver_financial_responsibility_signature,
      :driver_signature                                     => driver_signature,
      :additional_driver_signature                          => additional_driver_signature,
    })

    @charge.owner = @rental
    @charge.save

    rates.fetch(:rates).each do |l|
      rental_rate = RentalRate.create(:rental => @rental, :date => l.fetch('date'), :amount => l.fetch('rate'))
      @rental.line_items.create(l.except('rate').merge(charge: @charge, item: rental_rate))
    end
  end

  def failure_args
    {
      :errors             => errors,
      :stripe_customer_id => stripe_customer_id,
    }
  end

  def success_args
    {
      message:       "Rental #{@rental.number} created for #{driver_name_first} #{driver_name_last}.",
      rental_number: @rental.number,
    }
  end
end
