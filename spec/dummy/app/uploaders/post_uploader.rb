# encoding: utf-8

require "media_magick/image/dimensions"

class PostUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include MediaMagick::Image::Dimensions

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_fill => [960, 544]

  version :thumb do
    process :resize_to_fit => [250, 136]
  end

  version :big do
    process :resize_to_limit => [864, 489]
  end

end