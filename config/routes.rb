Rails.application.routes.draw do
  get 'sidebar_list/template'
  get 'sidebar_list/show'
  resources :reviews
  resources :users
  get 'sessions/new'

  get 'sidebar_list/displaySidebarList'

  resources :ratings
  resources :celebrities
  resources :movies
  resources :web_user
  match '/sidebar_list',      to: 'sidebar_list#temp',        via: 'post'
  match '/sidebar_list',      to: 'sidebar_list#temp1',        via: 'post'
  get 'home/index'

  root 'home#index'

  get '/login', to: 'home#login', as: 'login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
