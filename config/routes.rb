Rails.application.routes.draw do
  get 'sidebar_list/displaySidebarList'

  resources :ratings
  resources :celebrities
  resources :movies
  resources :web_users

  get 'home/index'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
