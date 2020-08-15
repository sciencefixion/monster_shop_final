Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #Original routes are commented out above newly rewritten routes

  # get :root, to: 'welcome#index'
  root 'welcome#index'

  # resources :merchants do
  #   resources :items, only: [:index]
  # end
  get '/merchants/:merchant_id/items', to: 'items#index', as: 'merchant_items'

  get '/merchants', to: 'merchants#index'
  post '/merchants', to: 'merchants#create'
  get '/merchants/new', to: 'merchants#new', as: 'new_merchant'
  get '/merchants/:id/edit', to: 'merchants#edit', as: 'edit_merchant'
  get '/merchants/:id', to: 'merchants#show', as: 'merchant'
  patch '/merchants/:id', to: 'merchants#update'
  delete '/merchants/:id', to: 'merchants#destroy'


  # resources :items, only: [:index, :show] do
  #   resources :reviews, only: [:new, :create]
  # end
  post '/items/:item_id/reviews', to: 'reviews#create', as: 'item_reviews'
  get '/items/:item_id/reviews/new', to: 'reviews#new', as: 'new_item_review'

  get '/items', to: 'items#index'
  get '/items/:id', to: 'items#show', as: 'item'


  # resources :reviews, only: [:edit, :update, :destroy]
  get '/reviews/:id/edit', to: 'reviews#edit', as: 'edit_review'
  patch '/reviews/:id', to: 'reviews#update', as: 'review'
  put '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy'


  # get '/cart', to: 'cart#show'
  # post '/cart/:item_id', to: 'cart#add_item'
  # delete '/cart', to: 'cart#empty'
  # patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  # delete '/cart/:item_id', to: 'cart#remove_item'
  scope :cart do
    get '/', to: 'cart#show'
    post '/:item_id', to: 'cart#add_item'
    patch '/:change/:item_id', to: 'cart#update_quantity'
    delete '/:item_id', to: 'cart#remove_item'
  end

  # Unable to scope the following route for some reason
  delete '/cart', to: 'cart#empty'


  # get '/registration', to: 'users#new', as: :registration
  scope :registration, as: :registration do
    get '/', to: 'users#new'
  end


  # resources :users, only: [:create, :update]
  post '/users', to: 'users#create', as: 'users'
  patch '/users/:id', to: 'users#update', as: 'user'
  put '/users/:id', to: 'users#update'
  patch '/users/:id', to: 'users#update'


  # get '/profile', to: 'users#show'
  # get '/profile/edit', to: 'users#edit'
  # get '/profile/edit_password', to: 'users#edit_password'
  scope :profile do
    get '/', to: 'users#show', as: 'profile'
    get '/edit', to: 'users#edit', as: 'profile_edit'
    get '/edit_password', to: 'users#edit_password', as: 'profile_edit_password'
  end


  # post '/orders', to: 'user/orders#create'
  # get '/profile/orders', to: 'user/orders#index'
  # get '/profile/orders/:id', to: 'user/orders#show'
  # delete '/profile/orders/:id', to: 'user/orders#cancel'
  # module :user do
  post '/orders', to: 'user/orders#create'
  get '/profile/orders', to: 'user/orders#index'
  get '/profile/orders/:id', to: 'user/orders#show'
  delete '/profile/orders/:id', to: 'user/orders#cancel'


  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'

  namespace :merchant do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :orders, only: :show
    resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
    put '/items/:id/change_status', to: 'items#change_status'
    get '/orders/:id/fulfill/:order_item_id', to: 'orders#fulfill'
    resources :discounts
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :merchants, only: [:show, :update]
    resources :users, only: [:index, :show]
    patch '/orders/:id/ship', to: 'orders#ship'
  end
end
