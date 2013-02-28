module MediaMagick
  module ApplicationHelper
    def attachment_uploader(model, relation, type, options={})
      id       = "#{model_name(model)}-#{relation.to_s}-#{type.to_s}"
      classes  = "attachmentUploader"
      data     = data_attributes(model, relation, options)
      template = "/uploader"

      if type == :video
        template = "/video_uploader"
        classes  = "attachmentVideoUploader"
      end

      content_tag :div, id: id, class: classes, data: data do
        if block_given?
          yield
        else
          render template
        end
      end
    end

    def attachment_loader(model, relation, options={})
      id   = "#{model_name(model)}-#{relation.to_s}-loadedAttachments"
      classes  = "loadedAttachments"
      data = data_attributes(model, relation, options)

      content_tag :div, id: id, class: classes, data: data do
        if block_given?
          yield
        else
          render partial:    '/loader',
                 collection: model.send(relation),
                 as:         :attachment,
                 locals:     { model: nil, relation: nil }
        end
      end
    end

    def attachment_container(model, relation, options = {})
      warn "%" * 50
      warn "[DEPRECATION] `attachment_container` is deprecated. please use `attachment_uploader`"
      warn "%" * 50
    end

    def attachment_container_for_video
      warn "%" * 50
      warn "[DEPRECATION] `attachment_container_for_video` is deprecated. please use `attachment_uploader`"
      warn "%" * 50
    end

    private
      def data_attributes(model, relation, options)
        data_attributes = {
          model:    model_name(model),
          id:       model.id.to_s,
          relation: relation.to_s
        }

        data_attributes.merge!(:partial => get_partial_name(options))
        data_attributes.merge!(:embedded_in_id => options[:embedded_in].id.to_s, :embedded_in_model => options[:embedded_in].class.to_s) if options[:embedded_in]

        data_attributes
      end

      def get_partial_name(options)
        return options[:partial] if options[:partial]
        '/loader'
      end

      def model_name(model)
        @model_name ||= model.class.to_s
      end
  end
end