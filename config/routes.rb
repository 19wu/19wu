NineteenWu::Application.routes.draw do

  resources :events do
    post 'join', :on => :member
  end
  get ":slug" => "group#event", :constraints => SlugConstraint
  get 'joined_events', to: "events#joined"
  match '/photos', to: "photo#create", :via => [:post, :put]

  authenticated :user do
    root to: "home#index"
  end
  as :user do
    root to: 'home#page'
  end
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
  get ':id(.:format)' => 'users#show'

  get 'mockup/:action(.:format)', :controller => 'mockup'
end
