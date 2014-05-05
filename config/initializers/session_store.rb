# Be sure to restart your server when you modify this file.

#RailsDynamicDomain::Application.config.session_store :cookie_store, key: '_rails-dynamic_session'
RailsDynamicDomain::Application.config.session_store :active_record_store, key: '_rails_dynamic_dns_session', httponly: true
ActiveRecord::SessionStore::Session.attr_accessible :data, :session_id
