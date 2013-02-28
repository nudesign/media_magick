class Post
  include Mongoid::Document
  include MediaMagick::Model

  field :title, :type => String
  field :text,  :type => String

  attaches_many :files,  :type => 'file'
  attaches_many :images, :type => 'image', :uploader => PostUploader, :allow_videos => true
  attaches_many :just_videos, :type => 'image', :uploader => PostUploader, :allow_videos => true
end
