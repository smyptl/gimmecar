require 'spec_helper'
require 'factories/rentals'
require 'factories/drivers'

describe Actions::ExtendRental do

  it 'extends rental' do
    drop_off = Time.current
    driver = create(:driver, create_stripe_id: true)
    rental = create(:rental, driver: driver, drop_off: drop_off)
    date = Date.today
    amount = 5000

    Actions::ExtendRental.new(rental: rental, date: Date.today, days: 1, amount: amount).execute

    expect(Charge.count).to eq(1)
    charge = Charge.first
    expect(charge.owner).to eq(rental)

    expect(LineItem.count).to eq(1)
    line_item = LineItem.first
    expect(line_item.amount).to eq(amount)
    expect(line_item.date).to_not eq(nil)

    rental = Rental.first
    expect(rental.drop_off).to eq(drop_off + 1.days)
  end
end
