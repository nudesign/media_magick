require 'action_controller/railtie'
require 'media_magick/controller/helpers'

module MediaMagick
  class AttachController < ActionController::Base
    include MediaMagick::Controller::Helpers

    def create
      if !params[:embedded_in_model].blank?
        embedded_in = params[:embedded_in_model].constantize.find(params[:embedded_in_id])
        obj = embedded_in.send(params[:model].pluralize.downcase).find(params[:id])
      else
        obj = params[:model].constantize.find(params[:id])
      end

      if params[:video]
        attachment = create_video(obj, params)
      else
        attachment = obj.send(params[:relation]).create(params[:relation].singularize => params[:file])
      end

      obj.save

      partial = params[:partial].blank? ? "/#{attachment.class::TYPE}" : params[:partial]

      render :partial => partial, :locals => {:model => params[:model], :relation => params[:relation], :attachment => attachment}
    end

    def destroy
      if !params[:embedded_in_model].blank?
        attachment = params[:embedded_in_model].classify.constantize.find(params[:embedded_in_id]).send(params[:model].pluralize.downcase).find(params[:id]).send(params[:relation].pluralize).find(params[:relation_id])
      else
        attachment = params[:model].classify.constantize.find(params[:id]).send(params[:relation].pluralize).find(params[:relation_id])
      end

      attachment.destroy
      render nothing: true
    end

    def update_priority
      attachments = params[:elements]
      attachments = attachments.split(',') unless attachments.kind_of?(Array)

      doc = find_doc_by_params(params)

      attachments.each_with_index do |id, i|
        attachment = doc.send(params[:relation]).find(id)
        attachment.priority = i
        attachment.save
      end

      render :text => params[:attachments]
    end

    def recreate_versions
      doc = find_doc_by_params(params)

      errors = []
      doc.send(params[:relation].pluralize).each do |attachment|
        errors << attachment unless attachment.recreate_versions!
      end

      if errors.empty?
        redirect_to :back, notice: t('media_magick.recreate_versions.ok')
      else
        redirect_to :back, notice: t('media_magick.recreate_versions.error')
      end
    end

  end
end
