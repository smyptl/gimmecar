require 'spec_helper'
require 'system/command/helpers/path_helper'
require 'system/command/helpers/user'

require 'factories/rentals'
require 'factories/line_items'

describe 'Return Deposit', type: :system, js: true do
  include_context :login_user

  scenario 'success' do
    deposit_amount = 4000
    charge_amount  = 2000
    amount         = deposit_amount + charge_amount
    rental         = create(:rental, :closed, pickup_odometer: 100, drop_off_odometer: 1400)
    charge         = create(:charge, :create_stripe_charge, amount: amount, owner: rental)
    deposit        = create(:line_item, :deposit, total: deposit_amount, charge: charge, invoice: rental)
    rental_rate    = create(:line_item, :rental_rate, total: charge_amount, charge: charge, invoice: rental)

    expect(LineItem.count).to eq(2)

    visit_command command_rental_path(id: rental.number)

    expect(page).to have_content(rental.number)
    find("a[data-toggle='dropdown']").click
    click_button('Return Deposit')

    expect(page).to have_content('Return Deposit')
    expect(page).to have_field('Amount', with: '$40.00')

    within('div.popup') do
      click_button('Return')
    end
    expect(page).to_not have_content('Return Deposit', wait: 2)

    expect(Charge.count).to eq(1)
    charge = Charge.first
    expect(charge.amount).to eq(charge_amount)
    stripe_charge = Stripe::Charge.retrieve(charge.stripe_charge_id)
    expect(stripe_charge['amount']).to eq(amount)
    expect(stripe_charge['amount_refunded']).to eq(deposit_amount)

    expect(LineItem.count).to eq(1)

    rental = Rental.first
    expect(rental.deposit).to eq(nil)
  end
end
