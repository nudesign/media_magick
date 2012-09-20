class Track
  include Mongoid::Document
  include MediaMagick::Model

  embedded_in :album

  attaches_many :files
  attaches_many :photos_and_videos, as: 'photo', uploader: PictureUploader, allow_videos: true
end
