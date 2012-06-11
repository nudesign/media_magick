module MediaMagick
  module ApplicationHelper
    def attachment_container(model, relation, newAttachments = {}, loadedAttachments = {}, options = {})
      data_attributes = {
        model:    model.class.to_s,
        id:       model.id.to_s,
        relation: relation.to_s
      }

      data_attributes.merge!(:partial => options[:partial]) if options[:partial]
      data_attributes.merge!(:embedded_in_id => options[:embedded_in].id.to_s, :embedded_in_model => options[:embedded_in].class.to_s) if options[:embedded_in]

      content_tag :div, id: model.class.to_s.downcase << '-' << relation.to_s, class: 'attachmentUploader ' << relation.to_s, data: data_attributes do
        if block_given?
          yield
        else
          partial_attributes = {
            model:             model,
            relations:         relation,
            newAttachments:    newAttachments,
            loadedAttachments: loadedAttachments,
            partial:           options[:partial]
          }

          render '/upload', partial_attributes
        end
      end
    end
  end
end
