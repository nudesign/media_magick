module MediaMagickHelper
  def attachment_container(model, relation)
    content_tag :div, id: model.class.to_s.downcase << '-' << relation.to_s, class: 'attachmentUploader', data: { model: model.class.to_s.downcase, id: model.id.to_s, relation: relation.to_s } do
      if block_given?
        yield
      else
        return render :partial => "/upload", :locals => { :model => model, :relations => relation }
      end
    end
  end
  
  def attachment(tag, model, options = {})
    default_options = options.merge(
      data: {
        id: model.id.to_s
      }
    )
    
    default_options[:class] << ' attachment'
    
    content_tag tag, default_options do
      yield if block_given?
    end
  end
end
