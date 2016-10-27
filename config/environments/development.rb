RailsDynamicDomain::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false
  config.assets.logger = nil
  config.assets.initialize_on_precompile = true
  
  config.log_level = :debug
  
  config.action_mailer.default_url_options = { :host => PRIVATE_DATA['url_host'] }
  config.action_mailer.delivery_method = PRIVATE_DATA['mailer_method'].to_sym

  if config.action_mailer.delivery_method == :smtp
    config.action_mailer.smtp_settings = {
      address: PRIVATE_DATA['mailer_address'],
      port: PRIVATE_DATA['mailer_port'],
      domain: PRIVATE_DATA['mailer_domain'],
      enable_starttls_auto: true,
      user_name: PRIVATE_DATA['mailer_user_name'],
      password: PRIVATE_DATA['mailer_password']
    }
  end


  # Set the logging destination(s)
  config.log_to = %w[stdout file]

  # Show the logging configuration on STDOUT
  config.show_log_configuration = true
end
