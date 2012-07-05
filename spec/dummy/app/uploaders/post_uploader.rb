# encoding: utf-8

class PostUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_fill => [50, 50]
  version :thumb do
    process :resize_to_fit => [300, 300]
  end

end