require 'action_controller/railtie'

class AttachController < ActionController::Base
  def create
    klass = params[:model].classify.constantize.find(params[:id])
    attachment = klass.send(params[:relation].pluralize).create(params[:relation].singularize => params[:file])
    klass.save
    
    render :partial => "/#{file.class::TYPE}", :locals => {:attachment => attachment}
  end
  
  def destroy
    attachment = params[:model].classify.constantize.find(params[:id]).send(params[:relation].pluralize).find(params[:relation_id])
    attachment.destroy
    render nothing: true
  end
end
