Rails.application.routes.draw do

  get 'gmails/connect_and_archive'

  resources :attachments
  #get 'static_pages/index'
  root to: "static_pages#index"
  
  resources :sessions, only: [:create, :destroy]
  
  
  # 1.Это ссылка которая инициирует запрос в гугл бд
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  # 2.После того как юзер авторизуется в приложении, 
  # провайдер редиректнет его к этому урл, так что мы можем исп-ть данные которые получили
  match '/auth/google_oauth2/callback', :to => 'sessions#create', via: [:get, :post]
  
  #Второй колбек для почты
  match '/gmails/refresh_emails', :to => 'gmails#refresh_emails', via: [:get, :post]

  # Создаёт простую форму входа где юзер увидет Connect with Google link
  get '/login', :to => 'sessions#new', :as => :login 
  # Роут для логаута (кнопки логаута)
  get '/signout', :to => 'sessions#destroy', :as => :signout 
  
  # Для ошибок если пользователь не авторизован или другая проблема
  get 'auth/failure', to: redirect('/')
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
