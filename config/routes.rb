Rails.application.routes.draw do

  get 'sidebar_list/template'
  get 'sidebar_list/boxoffice_hits'
  get 'sidebar_list/piechart'
  get 'sidebar_list/displaySidebarList'
  get 'sidebar_list/sample1'

  get 'sidebar_list/celebrity_prime_comp'
  get 'sidebar_list/celeb_rating_genre'
   get 'sidebar_list/celeb_rating'



  get 'sidebar_list/celeb_hits'
  resources :reviews
  resources :users
  get 'sessions/new'

  resources :ratings
  resources :celebrities
  resources :movies
  resources :web_user
  match '/sidebar_list/template',      to: 'sidebar_list#temp',        via: 'post'
  match '/sidebar_list',      to: 'sidebar_list#index',        via: 'get'

  match '/sidebar_list/template',      to: 'sidebar_list#paginate',        via: 'get'
  get 'home/index'

  match '/sidebar_list/boxoffice_hits',      to: 'sidebar_list#box2',        via: 'post'
  match '/sidebar_list/sample1',      to: 'sidebar_list#smpl1',        via: 'post'
  match '/sidebar_list/celeb_rating',      to: 'sidebar_list#smpl2',        via: 'post'

  match '/sidebar_list/celeb_hits',      to: 'sidebar_list#celeb_hts',        via: 'post'
  match '/sidebar_list/celebrity_prime_comp',      to: 'sidebar_list#smpl4',        via: 'post'
  match '/sidebar_list/celeb_rating_genre',      to: 'sidebar_list#celeb_genre',        via: 'post'

  get 'home/index'
  root 'home#index'

  get '/login', to: 'home#login', as: 'login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
