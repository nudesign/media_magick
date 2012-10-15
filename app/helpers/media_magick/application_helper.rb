module MediaMagick
  module ApplicationHelper
    def attachment_container(model, relation, options = {})
      data_attributes = {
        model:    model.class.to_s,
        id:       model.id.to_s,
        relation: relation.to_s
      }

      data_attributes.merge!(:partial => get_partial_name(options))
      data_attributes.merge!(:embedded_in_id => options[:embedded_in].id.to_s, :embedded_in_model => options[:embedded_in].class.to_s) if options[:embedded_in]

      content_tag :div, id: model.class.to_s.downcase << '-' << relation.to_s, class: 'attachmentUploader ' << relation.to_s, data: data_attributes do
        if block_given?
          yield
        else
          partial_attributes = {
            model:             model,
            relations:         relation,
            newAttachments:    options[:newAttachments]    || {},
            loadedAttachments: options[:loadedAttachments] || {},
            partial:           get_partial_name(options)
          }

          render '/upload', partial_attributes
        end
      end
    end

    def attachment_container_for_video(model, relation, options = {})
      data_attributes = {
        model:    model.class.to_s,
        id:       model.id.to_s,
        relation: relation.to_s
      }

      data_attributes.merge!(:partial => get_partial_name(options))
      data_attributes.merge!(:embedded_in_id => options[:embedded_in].id.to_s, :embedded_in_model => options[:embedded_in].class.to_s) if options[:embedded_in]

      content_tag :div, id: model.class.to_s.downcase << '-' << relation.to_s, class: 'attachmentVideoUploader ' << relation.to_s, data: data_attributes do
        if block_given?
          yield
        else
          partial_attributes = {
            model:             model,
            relations:         relation,
            newAttachments:    options[:newAttachments]    || {},
            loadedAttachments: options[:loadedAttachments] || {},
            load_attachments:  options[:load_attachments]  || false, #don't show attachments by default
            partial:           get_partial_name(options)
          }

          render '/video', partial_attributes
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
  end
end
