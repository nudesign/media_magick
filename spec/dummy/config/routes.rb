Rails.application.routes.draw do

  resources :posts
  resources :users

  root :to => "posts#index"

  mount MediaMagick::Engine => "/media_magick"
end
