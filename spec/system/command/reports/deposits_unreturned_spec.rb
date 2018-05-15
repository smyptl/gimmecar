require 'spec_helper'
require 'system/command/helpers/path_helper'
require 'system/command/helpers/user'

require 'factories/rentals'
require 'factories/line_items'

describe 'Deposits Unreturned', type: :system, js: true do
  include_context :login_user

  scenario 'show list of closed rentals with unreturned deposits' do
    rental  = create(:rental, :closed, pickup_odometer: 100, drop_off_odometer: 1400)
    deposit = create(:line_item, :deposit, invoice: rental)

    expect(LineItem.count).to eq(1)

    visit_command command_reports_path
    click_on 'Unreturned Deposits'
    expect(page).to have_content(rental.number)
  end
end
