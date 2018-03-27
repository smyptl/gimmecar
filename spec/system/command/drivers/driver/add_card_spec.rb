require 'spec_helper'
require 'system/command/helpers/path_helper'
require 'system/command/helpers/user'

require 'factories/drivers'
require 'system/helpers/payment'

describe 'Add card to driver file', type: :system, js: true do
  include_context :login_user

  scenario 'success' do
    driver = create(:driver, stripe_id: nil)

    visit_command command_driver_path(id: driver.id)

    expect(page).to have_content(driver.name)
    find("a[data-toggle='dropdown']").click
    click_button('Add Card')

    expect(page).to have_content('Add Card')

    fill_in_payment
    within('div.popup') do
      click_button('Add')
    end
    expect(page).to_not have_content('Add Card', wait: 4)

    driver = Driver.first
    expect(driver.stripe_id).to_not eq(nil)
    expect(driver.stripe_sources.count).to eq(1)
  end
end
