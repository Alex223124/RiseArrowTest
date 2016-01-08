Rails.application.routes.draw do

  root to: "static_pages#index"
  
  resources :sessions, only: [:create, :destroy]
  
  resources :incoming_messages, only: [:index, :show, :destroy]
  
  # 1.Cсылка которая инициирует запрос в гугл бд
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  # 2.После того как юзер авторизуется в приложении, 
  # провайдер редиректнет его к этому урл, так что мы можем исп-ть данные которые получили
  match '/auth/google_oauth2/callback', :to => 'sessions#create', via: [:get, :post]
  
  # refresh emails  button
  match '/incoming_messages/refresh_emails', :to => 'incoming_messages#refresh_emails', via: [:post]

  # Connect with Google link
  get '/login', :to => 'sessions#new', :as => :login 
  # Роут для логаута (кнопки логаута)
  get '/signout', :to => 'sessions#destroy', :as => :signout 
  
  # For errors
  get 'auth/failure', to: redirect('/')
 
end
