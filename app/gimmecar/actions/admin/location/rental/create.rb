class Actions::Admin::Location::Rental::Create < Lib::Forms::Base
  include Lib::Forms::Actions
  include Actions::Admin::Location::Rental::Concerns::Driver

  attributes do |a|
    a.date_time :drop_off

    a.signature :driver_financial_responsibility_signature
    a.signature :driver_signature

    a.signature :additional_driver_signature
    a.signature :additional_driver_financial_responsibility_signature

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

      @rental_logic = Logic::CalculateRental.new(self)

      Charge.new({ :amount => @rental_logic.total }).execute(success, failure, create_customer: stripe_customer_id.blank?, token: stripe_token, customer_id: stripe_customer_id)
    end
  end

  def save
    d = Driver.create(driver.except(:insurance).merge(:stripe_id => stripe_customer_id))
    InsurancePolicy.create(driver.fetch(:insurance).except(:verified).merge(:driver => d, :user_id => params.fetch(:user_id)))

    if add_additional_driver
      ad = AdditionalDriver.create(additional_driver)
    end

    @rental = Rental.create_open({
      :driver                                               => d,
      :additional_driver                                    => (ad if add_additional_driver),
      :vehicle_id                                           => vehicle_id,
      :vehicle_type                                         => vehicle_type,
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

    @rental_logic.line_items.each do |l|
      @rental.line_items.create(l)
    end
  end

  def success_args
    {
      message:       "Rental #{@rental.number} created for #{driver_first_name} #{driver_last_name}.",
      rental_number: @rental.number,
    }
  end

  def vehicle_type
    'compact'
  end

  def location
    @location ||= Location.find(params.fetch(:location_id))
  end

  def available_vehicle_ids
    location.available_vehicle_ids(rental_period)
  end
end
