Rails.application.routes.draw do

  mount MediaMagick::Engine => "/media_magick"
end
