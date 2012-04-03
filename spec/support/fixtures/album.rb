class Album
  include Mongoid::Document
  include MediaMagick::Model

  attachs_many :photos
  attachs_many :files
  
  attachs_many :images do
    field :tags, type: Array
  end
end
