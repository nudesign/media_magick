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
    end
  end
end