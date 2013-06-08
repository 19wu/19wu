NineteenWu::Application.routes.draw do
  get "autocomplete/users"

  resources :events, except: [:destroy] do
    member do
      post 'join'
      post 'quit'
      post 'follow'
      post 'unfollow'
      get 'followers'
      get 'checkin/:checkin_code', to: 'events#checkin', as: :checkin
    end
    resources :participants, :only => [:index, :update]
    resources :collaborators, :only => [:index, :create, :destroy]
  end

  get "events/:event_id/summary", to: "event_summaries#new", as: :new_event_summary
  post "events/:event_id/summary", to: "event_summaries#create", as: :create_event_summary
  put "events/:event_id/summary", to: "event_summaries#update"

  get ":slug" => "group#event", :constraints => SlugConstraint, :as => :slug_event
  get ":slug/followers" => "group#followers"
  get 'joined_events', to: "events#joined"
  match '/photos', to: "photo#create", :via => [:post, :put]
  post "/content/preview/" => "home#content_preview"

  authenticated :user do
    root to: "home#index"
  end
  as :user do
    root to: 'home#page'
    get 'cohort' => 'users#cohort'
    get 'invitations' => 'invitations#index'
    put '/invitations/:id/mail' => 'invitations#mail', :as => :mail_invitation
    get 'invitations/upgrade' => 'invitations#upgrade', :as => :upgrade_invitation
    put 'invitations/:id/upgrade_invite' => 'invitations#upgrade_invite', :as => :upgrade_invite_invitation
  end
  scope 'settings' do
    resource :profile, :only => [:show, :update]
    as :user do
      get 'account' => 'registrations#edit', :as => 'account'
    end
  end
  devise_for :users, :controllers => { :registrations => "registrations", :invitations => 'invitations' }

  namespace :api, defaults: {format: 'json'} do
    get '/events/:id/participants', to: "events#participants"
  end

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
