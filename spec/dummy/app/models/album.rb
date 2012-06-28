class Album
  include Mongoid::Document
  include MediaMagick::Model

  embeds_many :tracks

  attaches_many :photos
  attaches_many :files, :relation => :referenced, type: 'file'
  attaches_many :compound_name_files

  attaches_many :images do
    field :tags, type: Array
  end

  attaches_many :pictures, uploader: PictureUploader

  attaches_many :photos_and_videos, as: 'photo', uploader: PictureUploader, allow_videos: true
end
