# Load the Rails application.
require File.expand_path('../application', __FILE__)
PRIVATE_DATA = YAML.load_file("#{Rails.root}/config/private.yml")[Rails.env]

# Initialize the Rails application.
RailsDynamicDomain::Application.initialize!
