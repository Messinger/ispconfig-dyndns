source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1'
gem 'sprockets-rails' #,'2.1.3'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

platforms :ruby do
  gem 'pry'
  gem 'pry-rails'
  #see https://stackoverflow.com/questions/54527277/cant-activate-sqlite3-1-3-6-already-activated-sqlite3-1-4-0
  gem 'sqlite3', '~> 1.3', '< 1.4', group: :sqlite
#  gem 'sqlite3', group: :sqlite
  gem 'mysql2', '< 0.5.0', group: :mysql
end


# Use SCSS for stylesheets
gem 'sassc-rails'#, '~> 4.0.0'
# using bootstrap
gem 'bootstrap-sass'#, '~> 3.3.1'

group :assets do
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier'#, '>= 1.3.0'
  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails' #, '~> 4.0.0'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby
end
  
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# gem 'jquery-turbolinks'
# and mostly it breaks jquery... :( disabled

group :development do
  # thin is much better than webrick
  gem 'thin'
  gem 'seed_dump'
end

# using puma instead of passenger
gem 'puma'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'#, '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :debug do
  gem 'debase'
  gem 'ruby-debug-ide'
end

# security
gem 'cancan'
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-github'

# helpers
gem 'draper'
gem 'foreigner'
gem 'simple-navigation'
gem 'breadcrumbs_on_rails'
gem 'i18n-js'

gem 'logging-rails', :require => 'logging/rails'

# soap gedoehns

gem 'savon'

gem 'activerecord-session_store'

gem 'redis-mutex'
gem 'redis-rails'

gem 'font-awesome-rails'
