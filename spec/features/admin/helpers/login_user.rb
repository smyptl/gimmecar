shared_context :login_user do
  let(:user) { User.first || create(:user) }

  before(:each) do
    page.driver.browser.set_cookie('token=#{user.issue_token}')
  end
end
