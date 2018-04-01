class Actions::ReturnDeposit < Lib::Actions::Base

  attributes do |a|
    a.string  :number
    a.integer :amount
  end

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

  def amount
    read_attribute(:amount) || deposit.amount
  end

  def deposit
    @deposit ||= rental.deposit
  end
end
