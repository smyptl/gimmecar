class Actions::ExtendRental

  def initialize(rental:, amount:)
    @rental, @amount = rental, amount
  end

  def execute
    deposit = rental.deposit

    return unless deposit

    charge = deposit.charge

    Stripe::Refund.create(
      :charge => charge.stripe_charge_id,
      :amount => amount,
    )

    deposit.destroy
  end

  private

  def amount
    @amount || deposit.amount
  end
end
