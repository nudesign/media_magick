require 'active_support/concern'
require 'carrierwave/mongoid'
require 'media_magick/attachment_uploader'
require 'media_magick/video/parser'

module MediaMagick
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      # smell
      def attaches_many(name, options = {})
        attaches_block = block_given? ? Proc.new : nil

        name_camelcase = create_attaches_class(name, options, attaches_block) do
          if options[:allow_videos]
            raise "name 'videos' not allowed" if name.to_s == "videos"
            create_video_methods(name)
          end

          field :priority, type: Integer, default: 0

          default_scope asc(:priority)

          embedded_in(:attachmentable, polymorphic: true)
        end

        embeds_many(name, :as => :attachmentable, class_name: "#{self}#{name_camelcase}", cascade_callbacks: true)
      end

      # smell
      def attaches_one(name, options = {})
        attaches_block = block_given? ? Proc.new : nil

        name_camelcase = create_attaches_class(name, options, attaches_block) do
          if options[:allow_videos]
            raise "name 'video' not allowed" if name.to_s == "video"
            create_video_methods(name)
          end

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
          field :dimensions, type: Hash, default: {}

          before_destroy :cache_store_dir
          after_destroy :remove_directory

          def cache_store_dir
            @cache_store_dir = store_dir
          end

          def remove_directory
            FileUtils.remove_dir("#{Rails.root}/public/#{@cache_store_dir}", force: false)
          end

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

        # sets klass to a constant
        # ProductImages = klass
        constantize_embedded_klass(self, name_camelcase, klass)

        return name_camelcase
      end

      def constantize_embedded_klass(klass_self, relation_name, embedded_klass)
        parent = klass_self.parents.first # module or Object
        embedded_klass_name = "#{klass_self.to_s.demodulize}#{relation_name}"
        parent.const_set embedded_klass_name, embedded_klass
      end

    end
  end
end
