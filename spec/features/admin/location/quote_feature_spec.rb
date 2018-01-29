require 'spec_helper'
require 'features/admin/helpers/path_helper'
require 'features/admin/helpers/user_and_location'

require 'factories/rates'
require 'factories/tax_rates'

feature 'quote', js: true do
  include_context :login_user_and_select_location

  scenario 'gets quote' do
    create(:rate, vehicle_type: :compact, location: location, amount: 3500)
    create(:tax_rate, location: location)
    visit_admin admin_location_quote_path(slug: location.slug)

    expect(page).to have_content('Quote')

    select 'Compact (Toyota Corolla)', from: 'Vehicle Type'
    click_on 'Continue'

    expect(page).to have_content(location.description)
    expect(page).to have_content('Rental Details')
    expect(page).to have_content('Sales Tax')
  end
end
