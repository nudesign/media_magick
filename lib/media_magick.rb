warn <<~DEPRECATION
  [media_magick] DEPRECATED: This gem is no longer maintained and is incompatible
  with Rails 5+, CarrierWave 1+, MiniMagick 4+, and Mongoid 5+.
  Please migrate to Active Storage (ActiveRecord) or CarrierWave 3.x / Shrine (Mongoid).
  See https://github.com/nudesign/media_magick for details.
DEPRECATION

require 'rails/engine'
require 'plupload/rails'
require 'mini_magick'

require 'media_magick/model'
require 'media_magick/engine'
require 'media_magick/version'
