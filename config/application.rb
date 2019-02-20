require File.expand_path('../boot', __FILE__)

require 'rails/all'

CACHE_REDIS_HOST = ENV['REDIS_HOST']||'localhost'
CACHE_REDIS_PORT = ENV['REDIS_PORT']||6379

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module RailsDynamicDomain
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.cache_store = :redis_store, "redis://#{CACHE_REDIS_HOST}:#{CACHE_REDIS_PORT}/1/dyndns_cache", { expires_in: 90.minutes }
    config.assets.cache_store = :redis_store, "redis://#{CACHE_REDIS_HOST}:#{CACHE_REDIS_PORT}/1/dyndns_assets_cache", { expires_in: 90.minutes }
    config.sass.cache_store = :redis_store, "redis://#{CACHE_REDIS_HOST}:#{CACHE_REDIS_PORT}/1/dyndns_sass_cache", { expires_in: 90.minutes }
    Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = true

  end
end
