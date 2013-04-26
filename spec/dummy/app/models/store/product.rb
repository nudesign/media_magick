module Store
  class Product
    include Mongoid::Document
    include MediaMagick::Model

    field :name, :type => String

    attaches_many :images
  end
end