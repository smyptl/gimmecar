class Actions::Command::Rental::Extend < Lib::Actions::Base

  attr_reader :charge

  attributes do |a|
    a.string  :number
    a.date    :date
    a.integer :days
    a.integer :amount
    a.nested :source do |n|
      n.string  :customer_id
      n.string  :source_id
    end
    a.boolean :add_card
    a.string  :paid_by
    a.string  :stripe_token
  end

  validates :date,
    presence: true

  validates :days, :amount,
    presence: true,
    numericality: true

  #with_option unless: :add_card do
    validates :source_source_id, :source_customer_id,
      presence: true

    validate :valid_source_ids
  #end

  #with_options if: :add_card do
    #validates :paid_by,
      #presence: true,
      #inclusion: { in: ['driver', 'additional_driver'] }

    #validates :paid_by,
      #presence: true,
      #inclusion: { in: [:driver, :additional_driver] }

    #validates :stripe_token,
      #presence: true
  #end

  private

  def valid_source_ids
    if source_source_id && source_customer_id && !valid_sources.map(&:id).include?(source_source_id)
      errors.add(:source_source_id, 'invalid source selected')
    end
  end

  def valid_sources
    case source_customer_id
    when rental.driver_stripe_id
      rental.driver_stripe_sources[:data]
    when rental.additional_driver_stripe_id
      rental.additional_driver_stripe_sources[:data]
    end
  end

  def valid?
    if super
      success = lambda do |args|
        @charge = args.fetch(:charge)
        return true
      end

      failure = lambda do |args|
        errors.add(:base, args.fetch(:message))
        return false
      end

      Charge.new({ amount: charge_amount }).execute(success, failure, source_id: source_source_id, customer_id: source_customer_id)
    else
      false
    end
  end

  def success_args
    {
      number: rental.number,
      message: "Rental #{rental.number} extended by #{days} days, #{charge.amount} charged."
    }
  end

  def save
    charge.owner = rental
    charge.save

    current_date = read_attribute(:date)

    days.times do
      li           = LineItem.new(line_item_calculations)
      li.date      = current_date
      li.charge    = charge
      li.invoice   = rental
      li.item_type = 'rental_rate'
      li.save
      current_date += 1.days
    end

    rental.drop_off += days.days
    rental.save
  end

  def charge_amount
    line_item_calculations.fetch(:total) * days
  end

  def line_item_calculations
    @line_item ||= LineItem.calculate(amount: amount, date: nil, tax_rate: rental.tax_rate)
  end

  def stripe_customer_id
    rental.stripe_customer_id
  end

  def rental
    @rental ||= Rental.find_by(number: number)
  end
end
