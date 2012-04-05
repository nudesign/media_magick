module MediaMagickHelper
  def attachment_container(model, relation, newAttachments = {}, loadedAttachments= {})
    content_tag :div, id: model.class.to_s.downcase << '-' << relation.to_s, class: 'attachmentUploader ' << relation.to_s, data: { model: model.class.to_s, id: model.id.to_s, relation: relation.to_s } do
      if block_given?
        yield
      else
        render :partial => "/upload", :locals => { model: model, relations: relation, newAttachments: newAttachments, loadedAttachments: loadedAttachments }
      end
    end
  end
end
