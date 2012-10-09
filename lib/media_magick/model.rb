require 'active_support/concern'
require 'carrierwave/mongoid'
require 'media_magick/attachment_uploader'
require 'media_magick/video/parser'

module MediaMagick
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      def attaches_many(name, options = {})
        attaches_block = block_given? ? Proc.new : nil

        name_camelcase = create_attaches_class(name, options, attaches_block) do
          create_video_methods(name) if options[:allow_videos]

          field :priority, type: Integer, default: 0

          default_scope asc(:priority)

          embedded_in(:attachmentable, polymorphic: true)
        end

        embeds_many(name, :as => :attachmentable, class_name: "#{self}#{name_camelcase}")
      end

      def attaches_one(name, options = {})
        attaches_block = block_given? ? Proc.new : nil

        name_camelcase = create_attaches_class(name, options, attaches_block) do
          create_video_methods(name) if options[:allow_videos]

          embedded_in(name)
        end

        embeds_one(name, class_name: "#{self}#{name_camelcase}", cascade_callbacks: true)
      end

      private

      def create_attaches_class(name, options, attaches_block, &block)
        klass = Class.new do
          include Mongoid::Document
          extend CarrierWave::Mount

          field :type, type: String, default: options[:as] || 'image'

          def self.create_video_methods(name)
            field :video, type: String

            def video=(url)
              self.type = 'video'
              super

              video = MediaMagick::Video::Parser.new(url)

              send(self.class::ATTACHMENT).store!(video.to_image) if video.valid?
            end

            def source(options = {})
              video = MediaMagick::Video::Parser.new(self.video)

              video.to_html(options) if video.valid?
            end
          end

          class_eval(&block) if block_given?

          mount_uploader name.to_s.singularize, (options[:uploader] || AttachmentUploader)

          self.const_set "TYPE", options[:type] || :image
          self.const_set "ATTACHMENT", name.to_s.singularize

          class_eval(&attaches_block) if attaches_block

          def method_missing(method, args = nil)
            return self.send(self.class::ATTACHMENT).file.filename if method == :filename
            self.send(self.class::ATTACHMENT).send(method)
          end
        end

        name_camelcase = name.to_s.camelcase
        Object.const_set "#{self}#{name_camelcase}", klass

        return name_camelcase
      end
    end
  end
end
