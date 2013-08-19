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
    get 'qcode', to: 'participants#qcode'
    resources :participants , :only => [:index, :update]
    resources :collaborators, :only => [:index, :create, :destroy]
    resources :topics       , :only => [:new, :create, :show] do
      resource :reply       , :only => [:create]                  , :controller => 'topic_reply'
    end
    resources :export       , :only => [:index]
    resources :changes      , :only => [:index, :new, :create]    , :controller => 'event_changes'
    resources :tickets      , :controller => 'event_tickets'
    resources :orders       , :only => [:create]                  , :controller => 'event_orders'
  end

  get "events/:event_id/summary", to: "event_summaries#new", as: :new_event_summary
  post "events/:event_id/summary", to: "event_summaries#create", as: :create_event_summary
  patch "events/:event_id/summary", to: "event_summaries#update"

  get ":slug" => "group#event", :constraints => SlugConstraint, :as => :slug_event
  get ":slug/followers" => "group#followers"
  get 'ordered_events', to: "events#ordered"
  post '/photos', to: "photo#create"
  post "/content/preview/" => "home#content_preview"

  authenticated :user do
    root to: "home#index", as: :authenticated_root
  end
  as :user do
    root to: 'home#page'
    get 'cohort' => 'users#cohort'
    get 'invitations' => 'invitations#index'
    patch '/invitations/:id/mail' => 'invitations#mail', :as => :mail_invitation
    get 'invitations/upgrade' => 'invitations#upgrade', :as => :upgrade_invitation
    patch 'invitations/:id/upgrade_invite' => 'invitations#upgrade_invite', :as => :upgrade_invite_invitation
    resource :user_phone, only: [:edit, :update], format: false do
      post 'send_code'
    end
    resources :user_orders, only: [:index], format: false do
      member do
        get 'pay'
        get 'cancel'
        get 'request_refund'

        get 'alipay_done'
        post 'alipay_notify'
      end
    end
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

  mount ChinaCity::Engine => '/china_city'
  mount MailsViewer::Engine => '/delivered_mails' if defined?(MailsViewer)
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  # Fallback for /:login when user login is conflict with other routes
  #
  # Do not add :edit action or any other collection actions, the whole path is
  # preserved for any possible login name.
  resources :users, :path => '/u', :only => [:show]
  get ':id(.:format)' => 'users#show'

  get 'mockup/:action(.:format)', :controller => 'mockup'
end
