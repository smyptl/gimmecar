require 'spec_helper'
require 'features/admin/helpers/path_helper'

require 'factories/locations'
require 'factories/users'

feature 'Login', js: true do

  scenario 'login user' do
    user = create(:user)
    location = create(:location)
    user.locations << location

    visit_admin root_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: '1234'
    click_button 'Login'

    expect(page).to have_content(location.name)
    expect(current_path).to eq(location_dashboard_path(slug: location.slug))
  end
end
