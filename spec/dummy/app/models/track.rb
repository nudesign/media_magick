class Track
  include Mongoid::Document
  include MediaMagick::Model

  embedded_in :album

  attaches_many :files
end
