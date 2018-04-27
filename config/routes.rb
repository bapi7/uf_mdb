Rails.application.routes.draw do

  get 'sidebar_list/top_movies'
  get 'sidebar_list/boxoffice_hits'
  get 'sidebar_list/piechart'
  get 'sidebar_list/displaySidebarList'

  get 'sidebar_list/celebrity_prime_comp'
  get 'sidebar_list/celeb_rating_genre'
   get 'sidebar_list/celeb_rating'
   get 'sidebar_list/pop_production_votes'
   get 'sidebar_list/pop_production_critic'
   get 'sidebar_list/actor_age_hits'


  get 'sidebar_list/celeb_hits'
  resources :reviews
  resources :users
  get 'sessions/new'

  resources :ratings
  resources :celebrities
  resources :movies
  resources :web_user

  get 'home/index'

  get 'home/index'
  root 'home#index'

  get '/login', to: 'home#login', as: 'login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
