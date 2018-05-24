require 'spec_helper'
require 'system/command/helpers/path_helper'
require 'system/command/helpers/user'

require 'factories/rentals'
require 'factories/line_items'

describe 'Extend', type: :system, js: true do
  include_context :login_user

  scenario 'success' do
    drop_off  = Time.current
    days      = 2
    driver    = create(:driver, create_stripe_id: true)
    rental    = create(:rental, :open, driver: driver, drop_off: drop_off)
    line_item = create(:line_item, :rental_rate, amount: 4000, invoice: rental)

    expect(Charge.count).to eq(1)

    visit_command command_rental_path(id: rental.number)

    expect(page).to have_content(rental.number)
    find("a[data-toggle='dropdown']").click
    click_button('Extend')

    expect(page).to have_content('Extend')
    expect(page).to have_field('Amount', with: '$40.00')

    fill_in 'Days', with: days
    within('div.popup') do
      click_button('Extend')
    end
    expect(page).to_not have_content('Extend', wait: 2)

    expect(Charge.count).to eq(2)
    charge = Charge.last
    expect(charge.owner).to eq(rental)

    expect(LineItem.count).to eq(days + 1)
    line_item = LineItem.last
    expect(line_item.amount).to eq(line_item.amount)
    expect(line_item.date).to_not eq(nil)
    expect(line_item.charge).to eq(charge)

    rental = Rental.first
    expect(rental.drop_off).to eq(drop_off + days.days)
  end
end
