source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use postgres as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'autoprefixer-rails'
# User SLIM as the templating engine
gem 'slim'
gem 'slim-rails'
# Excel generator
gem 'zip-zip'
gem 'axlsx'
gem 'axlsx_rails'
# Webpack
gem 'webpacker'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use for Authentication
gem 'jwt'
# Audit Log
gem 'paper_trail'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

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
  gem 'listen', '>= 3.0.5', '< 3.2'
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
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  gem 'factory_bot'
  gem 'zonebie'
end

# Developer Tools
gem 'bugsnag'

# Gem
gem 'stripe', git: 'https://github.com/stripe/stripe-ruby'

# ActiveRecord Add-Ons
gem 'fuzzy_match'
gem 'groupdate'

ruby '2.5.0'
