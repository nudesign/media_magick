class Product
  include Mongoid::Document
  include MediaMagick::Model

  attachs_many :files
  attachs_many :images, uploader: PictureUploader do
    field :tags, type: Array
  end
end
