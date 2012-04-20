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

          if options[:relation] == :referenced
            belongs_to :attachmentable, polymorphic: true
          else
            embedded_in :attachmentable, polymorphic: true
          end

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

        if options[:relation] == :referenced
          klass.collection_name = "#{self.name}_#{name.to_s.camelcase}".parameterize

          has_many(name, :as => :attachmentable, class_name: "#{self}#{name_camelcase}")

          field "#{name.to_s.singularize}_ids", type: Array

          before_create do
            ids = self.send("#{name.to_s.singularize}_ids") || []

            ids.each do |id|
              "#{self.class}#{name_camelcase}".constantize.find(id).update_attributes(attachmentable: self)
            end
          end
        else
          embeds_many(name, :as => :attachmentable, class_name: "#{self}#{name_camelcase}")
        end
      end
    end
  end
end
