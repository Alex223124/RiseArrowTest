Rails.application.routes.draw do

  root to: "static_pages#index"
  
  resources :sessions, only: [:create, :destroy]
  
  resources :incoming_messages, only: [:index, :show, :destroy]
  
  # 1.Cсылка которая инициирует запрос в гугл бд
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  # 2.После того как юзер авторизуется в приложении, 
  # провайдер редиректнет его к этому урл, так что мы можем исп-ть данные которые получили
  match '/auth/google_oauth2/callback', :to => 'sessions#create', via: [:get, :post]
  
  # Кнопка refresh emails 
  match '/gmails/refresh_emails', :to => 'gmails#refresh_emails', via: [:get, :post]

  # Connect with Google link
  get '/login', :to => 'sessions#new', :as => :login 
  # Роут для логаута (кнопки логаута)
  get '/signout', :to => 'sessions#destroy', :as => :signout 
  
  # Для ошибок если пользователь не авторизован или другая проблема
  get 'auth/failure', to: redirect('/')
 
end
