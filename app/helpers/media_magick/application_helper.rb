module MediaMagick
  module ApplicationHelper
    def attachment_container(model, relation, options = {})
      data    = data_attributes(model, relation, options)
      id      = "#{model.class.to_s.downcase}-#{relation.to_s}"
      classes = "attachmentUploader #{relation.to_s}"

      content_tag :div, id: id, class: classes, data: data do
        if block_given?
          yield
        else
          options[:load_attachments] = true unless options[:load_attachments] == false

          render '/upload', partial_attributes(model, relation, options)
        end
      end
    end

    def attachment_container_for_video(model, relation, options = {})
      data    = data_attributes(model, relation, options)
      id      = "#{model.class.to_s.downcase}-#{relation.to_s}"
      classes = "attachmentUploader attachmentVideoUploader #{relation.to_s}"

      content_tag :div, id: id, class: classes, data: data do
        if block_given?
          yield
        else
          render '/video', partial_attributes(model, relation, options)
        end
      end
    end

    private
      def get_partial_name(options)
        if options[:partial]
          options[:partial]
        else
          if options[:as]
            "/#{options[:as]}"
          else
            '/image'
          end
        end
      end

      def data_attributes(model, relation, options)
        data_attributes = {
          model:    model.class.to_s,
          id:       model.id.to_s,
          relation: relation.to_s
        }

        data_attributes.merge!(:partial => get_partial_name(options))
        data_attributes.merge!(:embedded_in_id => options[:embedded_in].id.to_s, :embedded_in_model => options[:embedded_in].class.to_s) if options[:embedded_in]

        data_attributes
      end

      def partial_attributes(model, relation, options)
        partial_attributes = {
          model:             model,
          relations:         relation,
          newAttachments:    options[:newAttachments]    || {},
          loadedAttachments: options[:loadedAttachments] || {},
          load_attachments:  options[:load_attachments]  || false,
          partial:           get_partial_name(options)
        }

        partial_attributes
      end
  end
end
