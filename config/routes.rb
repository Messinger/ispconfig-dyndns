RailsDynamicDomain::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  match 'settings/edit',        :controller => 'settings', :action => 'edit',         :via => [:get,:post]
  match 'settings',             :controller => 'settings', :action => 'index',       :via => :get
  match 'settings/news',        :controller => 'settings', :action => 'news',        :via => [:get]

  scope '/user' do
    match '/login', to: 'sessions#userlogin',          :as => :user_login, :via => :get
    match '/sessions', to: 'sessions#create_for_user', :as => :create_session_for_user, :via => [:post]
    delete "/sessions/current" => "sessions#destroy"
  end

  resources :users
  
  scope '/admin' do
    match '/login', to: 'sessions#adminlogin',          :as => :admin_login, :via => :get
    match '/sessions', to: 'sessions#create_for_admin', :as => :create_session_for_admin, :via => [:post]
  end

  scope '/client' do
    match '/login', to: 'sessions#clientlogin',          :as => :client_login, :via => :get
    match '/sessions', to: 'sessions#create_for_client', :as => :create_session_for_client, :via => [:post]
  end

  match '/logout', to: 'sessions#destroy', :as => :user_logout, :via => :get

  resources :isp_dnszones, :only => [:index,:show]
  
  namespace :client do
    resources :dns_zones
  end
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
