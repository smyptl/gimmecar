require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GimmeCar
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Config Time Zone
    config.time_zone = 'Etc/UTC'
    config.active_record.default_timezone = :utc

    config.assets.initialize_on_precompile = false
  end
end
