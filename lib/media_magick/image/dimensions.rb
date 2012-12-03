module MediaMagick
  module Image
    module Dimensions
      extend ActiveSupport::Concern

      def size
        version_key = version_name.present? ? version_name : "_original"

        begin
          if model.dimensions[version_key.to_s].nil?
            image = MiniMagick::Image.open(file.path)
            model.dimensions[version_key.to_s] = {"width" => image[:width], "height" => image[:height]}
            model.save
          end

          return model.dimensions[version_key.to_s]
        rescue
          return {"width" => 0, "height" => 0}
        end
      end
    end
  end
end