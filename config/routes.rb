RailsDynamicDomain::Application.routes.draw do
  devise_for :admins, :controllers => {:sessions => 'admins/sessions',:unlocks => 'user/unlocks'}
  devise_for :users, :controllers => {
      :sessions => 'user/sessions',
      :registrations => "user/registrations",
      :omniauth_callbacks => 'user/omniauth_callbacks',
      :confirmations => 'user/confirmations',
      :unlocks => 'user/unlocks'
  }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  match 'settings/edit',        :controller => 'settings', :action => 'edit',         :via => [:get,:post]
  match 'settings',             :controller => 'settings', :action => 'index',       :via => :get
  match 'settings/news',        :controller => 'settings', :action => 'news',        :via => [:get]

  devise_scope :user do
    scope :users do
      match 'providers', to: 'user/sessions#omniauth_providers', :via => :get
      match 'close_sign_window', to: 'user/sessions#close_window', :via => :get
      match 'fetch_user', to: 'user/sessions#fetch_user', :via => :get
    end
  end

  scope :clients do
    match '', to: 'welcome#client_index', :as => :client_root, :via => :get
    match 'logout', to: 'client/sessions#destroy', :as => :destroy_client_user_session, :via => :delete
  end

  scope :admins do
    match '', to: 'welcome#admin_index', :as => :admin_root, :via => :get
    match 'edit', :to => 'admins/admins#edit', :via => [:get], :as => 'admin_edit'
    match 'update', :to => 'admins/admins#update', :via => [:put,:patch], :as => 'admin_update'
  end

  namespace :admins do
    resources :users, :only => [:index, :show, :destroy]
  end

  match '', to: 'welcome#user_index', :as => :user, :via => :get

  namespace :client do
    match 'login', to: 'sessions#clientlogin',          :as => :login, :via => :get
    match 'sessions', to: 'sessions#create_for_client', :as => :create_session, :via => [:post]
    resources :dns_zones, :only => [:index,:show,:destroy,:update]
    resource :dns_zones do
      post 'add_dnszone' => :add_dnszone, :as => :add
    end
    resources :isp_dnszones, :only => [:index,:show]
  end

  resources :dns_host_records
  match 'dynamic/update(/:accesstoken)' => 'dns_host_records#setip', via: [:get, :patch,:put,:post], :as => :update_dyndns
  match 'dyndns/update(/:accesstoken)' => 'dns_host_records#setip', via: [:get, :patch,:put,:post]

  # for omniauth
  match 'profile/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch, :post], :as => :finish_signup


  # catch all
  #
  match '*a', :to => 'welcome#routing', via: [:get,:patch,:put,:post]
end
