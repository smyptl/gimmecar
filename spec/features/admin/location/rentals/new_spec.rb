require 'spec_helper'
require 'features/admin/helpers/path_helper'
require 'features/admin/helpers/login_user'
require 'features/admin/helpers/location'

require 'factories/locations'
require 'factories/users'

feature 'Login', js: true do
  include_context :login_user
  include_context :location

  scenario 'login user' do
    visit_admin new_location_rental_path(:slug => location.slug)

    expect(page).to have_content("ASDF")
  end
end
