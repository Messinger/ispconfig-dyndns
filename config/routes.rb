RailsDynamicDomain::Application.routes.draw do
  devise_for :admins
  devise_for :users, :controllers => { :registrations => "user/registrations", :omniauth_callbacks => 'user/omniauth_callbacks' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  match 'settings/edit',        :controller => 'settings', :action => 'edit',         :via => [:get,:post]
  match 'settings',             :controller => 'settings', :action => 'index',       :via => :get
  match 'settings/news',        :controller => 'settings', :action => 'news',        :via => [:get]

  scope '/clients' do
    match '', to: 'welcome#client_index', :as => :client_root, :via => :get
    match '/logout', to: 'client/sessions#destroy', :as => :destroy_client_user_session, :via => :delete
  end

  scope '/admins' do
    match '', to: 'welcome#admin_index', :as => :admin_root, :via => :get
    match '/edit', :to => 'admins/admins#edit', :via => [:get], :as => 'admin_edit'
    match '/update', :to => 'admins/admins#update', :via => [:put,:patch], :as => 'admin_update'
  end

  namespace 'admins' do
    resources :users, :only => [:index, :show, :destroy]
  end

#  scope '/users' do
   match '', to: 'welcome#user_index', :as => :user, :via => :get
#  end

  
  namespace :client do
    match '/login', to: 'sessions#clientlogin',          :as => :login, :via => :get
    match '/sessions', to: 'sessions#create_for_client', :as => :create_session, :via => [:post]
    resources :dns_zones, :only => [:index,:show,:destroy,:update]
    resource :dns_zones do
      post 'add_dnszone' => :add_dnszone, :as => :add
    end
    resources :isp_dnszones, :only => [:index,:show]
  end

  resources :dns_host_records
  match '/dns_host_records/setip(/:accesstoken)' => 'dns_host_records#setip', via: [:get, :put]

  # for omniauth
  match '/profile/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  
end
