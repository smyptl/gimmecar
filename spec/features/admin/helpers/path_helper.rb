def visit_admin(path)
  using_app_host('http://admin.gc.local') do
    visit path
  end
end

def using_app_host(host)
  original_host = Capybara.app_host
  Capybara.app_host = host
  yield
ensure
  Capybara.app_host = original_host
end
