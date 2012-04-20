require 'action_controller/railtie'

module MediaMagick
  class AttachController < ActionController::Base
    def create
      if params[:model].constantize.relations[params[:relation]][:relation] == Mongoid::Relations::Referenced::Many
        klass = params[:model].constantize.where(id: params[:id])
        klass = klass.empty? ? nil : klass.first

        if klass
          attachment = klass.send(params[:relation].pluralize).create(params[:relation].singularize => params[:file])
        else
          attachment = params[:model].constantize.relations[params[:relation]][:class_name].constantize.create!(params[:relation].singularize => params[:file])
        end
      else
        klass = params[:model].constantize.find(params[:id])
        attachment = klass.send(params[:relation].pluralize).create(params[:relation].singularize => params[:file])
        klass.save
      end

      partial = params[:partial] || "/#{attachment.class::TYPE}"

      render :partial => partial, :locals => {:model => params[:model], :relation => params[:relation], :attachment => attachment}
    end

    def destroy
      attachment = params[:model].classify.constantize.find(params[:id]).send(params[:relation].pluralize).find(params[:relation_id])
      attachment.destroy
      render nothing: true
    end

    def update_priority
      attachments = params[:elements]
      attachments = attachments.split(',') unless attachments.kind_of?(Array)

      parent = params[:model].constantize.find(params[:model_id])

      attachments.each_with_index do |id, i|
        attachment = parent.send(params[:relation]).find(id)
        attachment.priority = i
        attachment.save
      end

      render :text => params[:attachments]
    end

    def recreate_versions
      parent = params[:model].classify.constantize.find(params[:model_id])

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
