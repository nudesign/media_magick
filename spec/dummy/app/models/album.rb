class Album
  include Mongoid::Document
  include MediaMagick::Model

  embeds_many :tracks

  attaches_many :photos
  attaches_many :files, :relation => :referenced
  attaches_many :compound_name_files

  attaches_many :images do
    field :tags, type: Array
  end

  attaches_many :pictures, uploader: PictureUploader
end
