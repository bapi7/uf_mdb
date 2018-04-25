Rails.application.routes.draw do
  get 'sidebar_list/show'
  resources :reviews
  resources :users
  resources :sidebar_list
  get 'sessions/new'

  get 'sidebar_list/displaySidebarList'

  resources :ratings
  resources :celebrities
  resources :movies
  resources :web_user

  get 'home/index'

  root 'home#index'

  get '/login', to: 'home#login', as: 'login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
