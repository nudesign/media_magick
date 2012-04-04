require 'action_controller/railtie'

class AttachController < ActionController::Base
  def create
    klass = params[:model].classify.constantize.find(params[:id])
    attachment = klass.send(params[:relation].pluralize).create(params[:relation].singularize => params[:file])
    klass.save

    render :partial => "/#{attachment.class::TYPE}", :locals => {:attachment => attachment}
  end

  def destroy
    attachment = params[:model].classify.constantize.find(params[:id]).send(params[:relation].pluralize).find(params[:relation_id])
    attachment.destroy
    render nothing: true
  end

  def update_priority
    attachments = params[:elements]
    attachments = attachments.split(',') unless attachments.kind_of?(Array)

    parent = params[:model].classify.constantize.find(params[:model_id])

    attachments.each_with_index do |id, i|
      attachment = parent.send(params[:relation]).find(id)
      attachment.priority = i
      attachment.save
    end

    render :text => params[:attachments]
  end
end
