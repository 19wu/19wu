NineteenWu::Application.routes.draw do
  match '/photos', to: "photo#create", :via => [:post, :put]

  # testing feature #109
  resources :events do
    member do
      post 'join'
    end
  end

  authenticated :user do
    root to: "home#index"
  end

  as :user do
    root to: 'devise/registrations#new'
  end

  resources :events

  scope 'settings' do
    resource :profile, :only => [:show, :update]
    as :user do
      get 'account' => 'registrations#edit', :as => 'account'
    end
  end

  devise_for :users, :controllers => { :registrations => "registrations" }

  if defined?(MailsViewer)
    mount MailsViewer::Engine => '/delivered_mails'
  end

  # Fallback for /:login when user login is conflict with other routes
  #
  # Do not add :edit action or any other collection actions, the whole path is
  # preserved for any possible login name.
  resources :users, :path => '/u', :only => [:show]

  get 'mockup/:action(.:format)', :controller => 'mockup'

  get ':id(.:format)' => 'users#show'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
