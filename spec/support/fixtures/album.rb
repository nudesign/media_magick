class Album
  include Mongoid::Document
  include MediaMagick::Model

  attachs_many :photos
end
