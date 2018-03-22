require 'factories/users'

shared_context :login_user do
  let(:user) { User.first || create(:user) }

  before(:each) do
    visit_command root_path

    user

    fill_in 'Email', with: user.email
    fill_in 'Password', with: '1234'
    click_button 'Login'

    expect(page).to have_content ('Rentals')
    expect(current_path).to include(command_rentals_path)
  end
end
