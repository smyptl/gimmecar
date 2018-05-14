require 'spec_helper'
require 'system/command/helpers/path_helper'
require 'system/command/helpers/user'

require 'factories/locations'
require 'factories/rates'
require 'factories/tax_rates'

describe 'quote', type: :system, js: true do
  include_context :login_user

  scenario 'gets quote' do
    location = create(:location)
    create(:rate, vehicle_type: :compact, location: location, amount: 3500)
    create(:tax_rate, location: location)

    visit_command command_quote_path(slug: location.slug)

    expect(page).to have_content('Quote')

    select location.name, from: 'Location'
    find('td', text: 'Compact').click
    click_on 'Continue'

    expect(page).to have_content('Rental Details')
    expect(page).to have_content('Sales Tax')
  end
end
