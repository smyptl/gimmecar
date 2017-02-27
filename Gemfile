source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

gem 'jbuilder'

# Use postgres as the database for Active Record
gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 3.0'
gem 'foreman'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'autoprefixer-rails'
gem 'roadie-rails'

# User SLIM as the templating engine
gem 'slim'
gem 'slim-rails'

# Webpack
gem 'webpacker', github: 'rails/webpacker'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use for Authentication
gem 'jwt'

# Audit Log
gem 'paper_trail'

group :development, :test, :staging do
  # Seed Data
  gem 'faker'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Email Opener
  gem 'letter_opener'
  # Annotate
  gem 'annotate'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'factory_girl'
  gem 'database_cleaner'
end

# Developer Tools
gem 'bugsnag'

# Gem
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby '2.4.0'
