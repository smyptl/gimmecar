class Actions::ReturnDeposit

  def initialize(rental:, amount: nil)
    @rental, @amount = rental, amount
  end

  def execute
    if deposit
      charge = deposit.charge

      Stripe::Refund.create(
        :charge => charge.stripe_charge_id,
        :amount => amount,
      )

      deposit.destroy

      charge.amount -= amount
      charge.save

      puts 'success'
    end
  end

  private

  def amount
    @amount || deposit.amount
  end

  def deposit
    @deposit ||= @rental.deposit
  end
end
