require 'action_controller/railtie'

module MediaMagick
  class AttachController < ActionController::Base
    def create
      if !params[:embedded_in_model].blank?
        embedded_in = params[:embedded_in_model].constantize.find(params[:embedded_in_id])
        klass = embedded_in.send(params[:model].pluralize.downcase).find(params[:id])
      else
        klass = params[:model].constantize.find(params[:id])
      end

      if params[:video]
        attachment = klass.send(params[:relation].pluralize).create(video: params[:video])
      else
        attachment = klass.send(params[:relation].pluralize).create(params[:relation].singularize => params[:file])
      end

      klass.save

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

      if !params[:embedded_in_model].blank?
        parent = params[:embedded_in_model].classify.constantize.find(params[:embedded_in_id]).send(params[:model].pluralize.downcase).find(params[:model_id])
      else
        parent = params[:model].constantize.find(params[:model_id])
      end

      attachments.each_with_index do |id, i|
        attachment = parent.send(params[:relation]).find(id)
        attachment.priority = i
        attachment.save
      end

      render :text => params[:attachments]
    end

    def recreate_versions
      if !params[:embedded_in_model].blank?
        parent = params[:embedded_in_model].classify.constantize.find(params[:embedded_in_id]).send(params[:model].pluralize.downcase).find(params[:model_id])
      else
        parent = params[:model].classify.constantize.find(params[:model_id])
      end

      errors = []
      parent.send(params[:relation].pluralize).each do |attachment|
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
