Rails.application.routes.draw do

  root to: "static_pages#index"
  
  resources :sessions, only: [:create, :destroy]
  resources :incoming_messages, only: [:index, :show, :destroy]
  
  # 1.Initialization
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  # 2.Callback
  match '/auth/google_oauth2/callback', :to => 'sessions#create', via: [:get, :post]
  
  # "refresh emails" button
  match '/incoming_messages/refresh_emails', :to => 'incoming_messages#refresh_emails', via: [:post]

  get '/login', :to => 'sessions#new', :as => :login 
  get '/signout', :to => 'sessions#destroy', :as => :signout 
  get 'auth/failure', to: redirect('/')
 
end
