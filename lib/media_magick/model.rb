require 'active_support/concern'
require 'carrierwave/mongoid'
require 'media_magick/attachment_uploader'

module MediaMagick
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      def attachs_many(name, options = {}, &block)
        klass = Class.new do
          include Mongoid::Document
          extend CarrierWave::Mount

          field :priority, type: Integer, default: 0
          default_scope asc(:priority)

          embedded_in :attachmentable, polymorphic: true
          mount_uploader name.to_s.singularize, (options[:uploader] || AttachmentUploader)

          self.const_set "TYPE", options[:type] || :image
          self.const_set "ATTACHMENT", name.to_s.singularize

          class_eval(&block) if block_given?

          def method_missing(method, args = nil)
            return self.send(self.class::ATTACHMENT).file.filename if method == :filename
            self.send(self.class::ATTACHMENT).send(method)
          end
        end

        name_camelcase = name.to_s.camelcase
        Object.const_set "#{self.name}#{name_camelcase}", klass

        embeds_many(name, :as => :attachmentable, class_name: "#{self}#{name_camelcase}")
      end
    end
  end
end
