module MediaMagick
  module Controller
    module Helpers
      extend ActiveSupport::Concern

      # {"embedded_in_model"=>"embedded_model",
      #   "embedded_in_id"=>"embedded_id", "model"=>"model",
      #   "model_id"=>"id"
      # }
      def find_doc_by_params(params)
        if params[:embedded_in_model].blank?
          doc = params[:model].classify.constantize.find(params[:model_id])
        else
          doc = params[:embedded_in_model].classify.constantize.find(params[:embedded_in_id]).send(params[:model].pluralize.downcase).find(params[:model_id])
        end
        doc
      end

      # Creates a video based on a url
      #
      # @example Creates a video for an user
      #   user   = User.create
      #   params = {relation: "photo", video: "youtube.com/watch?v=FfUHkPf9D9k"}
      #   create_video(user, params)
      #
      # @param [ Mongoid::Document ] Mongoid document object
      # @param [ Hash ] Hash with relation name and video url
      #
      # @return [ Mongoid::Document ] The mongoid document object
      def create_video(obj, params)
        relation_metadata = obj.class.relations[params[:relation]]

        unless relation_metadata.many? # one
          return obj.send("create_#{params[:relation]}", {video: params[:video]})
        end
        obj.send(params[:relation]).create(video: params[:video])
      end
    end
  end
end
