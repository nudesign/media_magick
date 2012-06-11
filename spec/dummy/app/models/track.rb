class Track
  include Mongoid::Document
  include MediaMagick::Model

  embedded_in :album

  attachs_many :files
end
