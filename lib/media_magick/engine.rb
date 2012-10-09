module MediaMagick
  class Engine < ::Rails::Engine
    isolate_namespace MediaMagick

    initializer 'media_magick.include_helper' do
      ActionView::Base.send :include, MediaMagick::ApplicationHelper
    end
  end
end