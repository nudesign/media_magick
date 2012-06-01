class User
  include Mongoid::Document
  include MediaMagick::Model

  attachs_one :photo
  attachs_one :compound_name_file
end