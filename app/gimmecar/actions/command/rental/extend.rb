class Actions::Command::Rental::Extend < Lib::Actions::Base

  attr_reader :charge

  attributes do |a|
    a.string  :number
    a.date    :date
    a.integer :days
    a.integer :amount
  end

  validates :date,
    presence: true

  validates :days, :amount,
    presence: true,
    numericality: true

  private

  def valid?
    valid = super

    if valid
      success = lambda do |args|
        @charge = args.fetch(:charge)
        return true
      end

      failure = lambda do |args|
        errors.add(:base, args.fetch(:message))
        return false
      end

      Charge.new({ amount: charge_amount }).execute(success, failure, customer_id: stripe_customer_id)
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
      li           = LineItem.new(line_item_calculations.merge(date: current_date))
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
    @total ||= line_item_calculations.fetch(:total)*days
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