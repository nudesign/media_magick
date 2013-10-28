Dummy::Application.routes.draw do

  namespace :store do
    resources :products
  end


  resources :posts
  resources :users

  root :to => "posts#index"

  mount MediaMagick::Engine => "/media_magick"
end
