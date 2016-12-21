# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
#run Rails.application

if defined?(PhusionPassenger) && !ENV['SERVER_SOFTWARE'].nil? && ENV['SERVER_SOFTWARE'].match(/[Aa]pache/)
  run Rails.application
else
  map ENV['RAILS_RELATIVE_URL_ROOT']||'/' do
    run Rails.application
  end
end

