require 'json'
require 'net/http'

module MediaMagick
  class VideoParser
    def initialize(url)
      @url = url
    end

    def valid?
      youtube_regex = /((https?)?:\/\/)?(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\S)*/
      vimeo_regex = /((https?):\/\/)?(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/

      if @url.match(youtube_regex)
        @id = @url.match(youtube_regex)[5]
        @service = 'youtube'
        true
      else
        if @url.match(vimeo_regex)
          @id = @url.match(vimeo_regex)[4]
          @service = 'vimeo'
          true
        else
          false
        end
      end
    end

    def to_image
      id = @id if valid?

      case @service
      when 'youtube'
        image_url = "http://img.youtube.com/vi/#{id}/0.jpg"
      when 'vimeo'
        uri = URI.parse("http://vimeo.com/api/v2/video/#{id}.json")
        resp = Net::HTTP.get_response(uri)
        image_url = JSON.parse(resp.body)[0]["thumbnail_large"]
      end

      uri = URI.parse(image_url)
      response = Net::HTTP.get_response(uri)

      File.new("/tmp/#{id}.jpg",  "w+").tap do |file|
        file.write(response.body.force_encoding('UTF-8'))
      end
    end

    def to_html(options = {})
      valid?

      case @service
      when 'youtube'
        "<iframe width=\"#{ options[:width] || 560}\" height=\"#{ options[:height] || 315 }\" src=\"http://www.youtube.com/embed/#{@id}\" frameborder=\"0\" allowfullscreen></iframe>"
      when 'vimeo'
        "<iframe src=\"http://player.vimeo.com/video/#{@id}?title=0&byline=0&portrait=0\" width=\"#{ options[:width] || 500 }\" height=\"#{ options[:height] || 341 }\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"
      end
    end
  end
end
