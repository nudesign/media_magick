Rails.application.routes.draw do

  resources :users

  mount MediaMagick::Engine => "/media_magick"
end
