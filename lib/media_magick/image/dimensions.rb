module MediaMagick
  module Image
    module Dimensions
      extend ActiveSupport::Concern

      def size
        begin
          if model.dimensions.empty?
            image = MiniMagick::Image.open(file.path)
            model.dimensions = {width: image[:width], height: image[:height]}
            model.save
          end

          return model.dimensions
        rescue
          return {width: 0, height: 0}
        end
      end
    end
  end
end

# img = MiniMagick::Image.open(self.image.small.file.path)
# self.dimensions[style] = {:width => img[:width], :height => img[:height]}
# self.save

# begin
#   @image ||= MiniMagick::Image.open(file.path)
#   return @image
# rescue
#   return {width: 0, height: 0}
# end