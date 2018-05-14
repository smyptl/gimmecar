class Actions::Admin::Location::Rental::New::Create < Lib::Actions::Base
  include Actions::Admin::Location::Rental::New::Concerns::Driver
  include Actions::Admin::Location::Rental::New::Concerns::Vehicle
  include Actions::Admin::Location::Rental::New::Concerns::FinancialResponsibility
  include Actions::Admin::Location::Rental::New::Concerns::TermsAndConditions

  attributes do |a|
    a.time :drop_off

    a.string :promo_code
    a.symbol :paid_by

    a.string :stripe_customer_id
    a.string :stripe_token
  end

  validates :drop_off,
    presence: true,
    after_date: { with: -> { pickup }, message: 'must be after pickup', allow_nil: true }

  validates :paid_by,
    presence: true,
    inclusion: { in: [:driver, :additional_driver] }

  def pickup
    Time.current
  end

  def rental_period
    return unless pickup && drop_off
    return unless pickup.before?(drop_off)
    @rental_period ||= Lib::DateRange.new(pickup, drop_off)
  end

  def rates
    @rates ||= Services::Rates.new(rental: self, location: location).retrieve!
  end

  def location
    @location ||= Location.find(params.fetch(:location_id))
  end

  def valid?
    valid = super

    if valid
      success = lambda do |args|
        @charge = args.fetch(:charge)
        write_attribute(:stripe_customer_id, args.fetch(:customer_id))
        true
      end

      failure = lambda do |args|
        errors.add(:card, args.fetch(:message))
        write_attribute(:stripe_customer_id, args.fetch(:customer_id))
        false
      end

      charge_amount = rates.fetch(:total) + Rental::DEPOSIT_AMOUNT

      Charge.new({ amount: charge_amount }).execute(success, failure, token: stripe_token, customer_id: stripe_customer_id)
    end
  end

  def save
    @rental = Rental.create_open({
      driver:                                               create_primary_driver,
      additional_driver:                                    create_additional_driver,
      vehicle_id:                                           vehicle_id,
      tax_rate:                                             location.latest_tax_rate,
      pickup_location:                                      location,
      pickup:                                               pickup,
      pickup_odometer:                                      pickup_odometer,
      pickup_fuel:                                          pickup_fuel,
      drop_off_location:                                    location,
      drop_off:                                             drop_off,
      collision_damage_waiver:                              false,
      driver_financial_responsibility_signature:            driver_financial_responsibility_signature,
      driver_signature:                                     driver_signature,
      additional_driver_financial_responsibility_signature: (additional_driver_financial_responsibility_signature if add_additional_driver),
      additional_driver_signature:                          (additional_driver_signature                          if add_additional_driver),
    })

    @charge.owner = @rental
    @charge.save

    rates.fetch(:rental_rates).each do |l|
      @rental.line_items.create(l.merge(charge: @charge, item_type: :rental_rate))
    end

    deposit = LineItem.calculate(date: pickup, amount: Rental::DEPOSIT_AMOUNT, taxable_amount: 0, tax_rate: location.latest_tax_rate)
    @rental.line_items.create(deposit.merge(charge: @charge, item_type: :deposit))
  end

  def create_primary_driver
    create_driver(attributes: read_attribute(:driver), paid_by: paid_by_primary_driver?)
  end

  def create_additional_driver
    if add_additional_driver
      create_driver(attributes: read_attribute(:additional_driver), paid_by: paid_by_additional_driver?)
    end
  end

  def create_driver(attributes:, paid_by:)
    driver = Driver.create(attributes.except(:insurance, :email, :phone_numbers, :address)) do |d|
      d.stripe_id = stripe_customer_id if paid_by
    end

    if attributes.fetch(:insurance, false)
      InsurancePolicy.create(attributes.fetch(:insurance)
                                       .except(:verified)
                                       .merge(driver: driver, user_id: params.fetch(:user_id)))
    end

    save_email(email: attributes.fetch(:email), driver: driver)
    save_phone_numbers(numbers: attributes.fetch(:phone_numbers), driver: driver)
    save_address(address: attributes.fetch(:address), driver: driver)

    driver
  end

  def save_phone_numbers(numbers:, driver:)
    numbers.compact.each do |type, number|
      PhoneNumber.create({
        owner:      driver,
        phone_type: type,
        number:     number,
      })
    end
  end

  def save_email(email:, driver:)
    Email.create(email: email, primary: true, owner: driver)
  end

  def save_address(address:, driver:)
    Address.create(address.merge(owner: driver))
  end

  def paid_by_primary_driver?
    !paid_by_additional_driver?
  end

  def paid_by_additional_driver?
    add_additional_driver && paid_by == :additional_driver
  end

  def failure_args
    {
      errors:             errors,
      stripe_customer_id: stripe_customer_id,
    }
  end

  def success_args
    {
      message: "Rental #{@rental.number} created for #{driver_name_first} #{driver_name_last}.",
      number:  @rental.number,
    }
  end

  def time_zone
    location.time_zone
  end
end
