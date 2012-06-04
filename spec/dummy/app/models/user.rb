class User
  include Mongoid::Document
  include MediaMagick::Model

  field :name, type: String

  attaches_one :photo, uploader: PictureUploader
  attaches_one :compound_name_file
  attaches_one :file, type: :file
end