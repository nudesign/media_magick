require 'active_support/concern'
require 'mongoid'

module MediaMagick
  module Model
    extend ActiveSupport::Concern
    
    module ClassMethods
      def attach_many(name, &block)
        klass = Class.new do
          include Mongoid::Document
          
          embedded_in :attachmentable, polymorphic: true
          
          class_eval(&block) if block_given?
        end
        
        Object.const_set "#{self.name}#{name.capitalize}", klass
        
        embeds_many(name, :as => :attachmentable, class_name: "#{self}#{name.capitalize}")
      end
    end
  end
end
