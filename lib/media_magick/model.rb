require 'active_support/concern'
require 'carrierwave'
require 'media_magick/image_uploader'
require 'mongoid'

module MediaMagick
  module Model
    extend ActiveSupport::Concern
    
    module ClassMethods
      def attach_many(name, options = {}, &block)
        klass = Class.new do
          include Mongoid::Document
          extend CarrierWave::Mount
          
          embedded_in :attachmentable, polymorphic: true
          mount_uploader name.to_s.singularize, ImageUploader unless options[:custom_uploader]
          
          class_eval(&block) if block_given?
        end
        
        Object.const_set "#{self.name}#{name.capitalize}", klass
        
        embeds_many(name, :as => :attachmentable, class_name: "#{self}#{name.capitalize}")
      end
    end
  end
end
