require 'spec_helper'
require 'factories/rentals'

describe Actions::ReturnDeposit do

  it 'refunds deposit amount' do
    deposit_amount = 20000
    charge_amount = 4000

    rental = create(:rental)

    c = Charge.new(amount: deposit_amount + charge_amount)
    c.execute(
      double(:success, :call => true),
      double(:failure, :call => true),
      token: 'tok_visa',
      customer_id: nil)
    c.owner = rental
    c.save

    deposit = LineItem.new(LineItem.calculate(amount: deposit_amount, date: Date.today, taxable_amount: 0, tax_rate: rental.tax_rate))
    deposit.item_type = :deposit
    deposit.charge = c
    deposit.invoice = rental
    deposit.save

    expect(LineItem.deposits.count).to eq(1)

    Actions::ReturnDeposit.new(rental: rental).execute

    charge = Charge.first
    expect(charge.amount).to eq(charge_amount)

    expect(LineItem.count).to eq(0)

    stripe_charge = Stripe::Charge.retrieve(charge.stripe_charge_id)
    expect(stripe_charge['amount']).to eq(charge_amount + deposit_amount)
    expect(stripe_charge['amount_refunded']).to eq(deposit_amount)
  end
end
