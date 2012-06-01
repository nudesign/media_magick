class Product
  include Mongoid::Document
  include MediaMagick::Model

  attaches_many :files
  attaches_many :images, uploader: PictureUploader do
    field :tags, type: Array
  end
end
