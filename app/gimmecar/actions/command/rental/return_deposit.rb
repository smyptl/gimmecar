class Actions::Command::Rental::ReturnDeposit < Lib::Actions::Base

  attributes do |a|
    a.string  :number
    a.integer :amount
  end

  validates :amount,
    presence: true,
    numericality: { less_than_or_equal_to: :deposit_amount }

  private

  def success_args
    {}
  end

  def save
    if deposit
      charge = deposit.charge

      Stripe::Refund.create(
        charge: charge.stripe_charge_id,
        amount: amount,
      )

      deposit.destroy

      charge.amount -= amount
      charge.save
    end
  end

  private

  def rental
    @rental ||= Rental.find_by(number: number)
  end

  def deposit
    @deposit ||= rental.deposit
  end

  def deposit_amount
    rental.deposit_amount
  end
end
