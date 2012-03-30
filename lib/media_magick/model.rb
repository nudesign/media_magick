require 'active_support/concern'
require 'carrierwave/mongoid'
require 'media_magick/attachment_uploader'
require 'mongoid'

module CarrierWave
  module Uploader
    module Url
      extend ActiveSupport::Concern
      include CarrierWave::Uploader::Configuration

      ##
      # === Returns
      #
      # [String] the location where this file is accessible via a url
      #
      def url
        if file.respond_to?(:url) and not file.url.blank?
          file.url
        elsif current_path
          (base_path || "") + File.expand_path(current_path).gsub(File.expand_path(CarrierWave.root), '')
        end
      end
    end
  end
end

module MediaMagick
  module Model
    extend ActiveSupport::Concern
    
    module ClassMethods
      def attachs_many(name, options = {}, &block)
        klass = Class.new do
          include Mongoid::Document
          extend CarrierWave::Mount

          embedded_in :attachmentable, polymorphic: true
          mount_uploader name.to_s.singularize, AttachmentUploader unless options[:custom_uploader]

          self.const_set "TYPE", options[:type] || :image
          
          class_eval(&block) if block_given?
        end

        Object.const_set "#{self.name}#{name.capitalize}", klass

        embeds_many(name, :as => :attachmentable, class_name: "#{self}#{name.capitalize}")
      end
    end
  end
end
