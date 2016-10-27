# Be sure to restart your server when you modify this file.

SESSION_REDIS_HOST = ENV['REDIS_HOST']||'localhost'
SESSION_REDIS_PORT = ENV['REDIS_PORT']||6379

RailsDynamicDomain::Application.config.session_store :redis_store, servers: {
  host: SESSION_REDIS_HOST,
  port: SESSION_REDIS_PORT,
  namespace: "dyndns_sessions",
},
expires_in: 90.minutes, key: '_dyndns_session',  path: ENV['RAILS_RELATIVE_URL_ROOT']||'/', httponly: true, secure: !(Rails.env.development? || Rails.env.test?)
