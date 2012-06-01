class User
  include Mongoid::Document
  include MediaMagick::Model

  attaches_one :photo
  attaches_one :compound_name_file
end