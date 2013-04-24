module Store
  class Product
    include Mongoid::Document
    include MediaMagick::Model

    attaches_many :images
  end
end