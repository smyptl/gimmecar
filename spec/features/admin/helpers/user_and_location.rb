require 'factories/users'
require 'factories/locations'

shared_context :login_user_and_select_location do
  let(:user) { User.first || create(:user) }
  let(:location) do
    location = create(:location)
    user.locations << location
    location
  end

  before(:each) do
    visit_admin root_path

    user
    location

    expect(page.driver.console_messages).to eq([])

    fill_in 'Email', with: user.email
    fill_in 'Password', with: '1234'
    click_button 'Login'

    expect(page).to have_content(location.name)
    expect(current_path).to eq(location_dashboard_path(slug: location.slug))
  end
end
