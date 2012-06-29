require 'spec_helper'

describe MediaMagick::VideoParser do
  describe 'youtube' do
    describe 'valid?' do
      context 'with a valid url' do
        subject { MediaMagick::VideoParser.new('youtube.com/watch?v=FfUHkPf9D9k') }

        it { should be_valid }
      end

      context 'with a invalid url' do
        subject { MediaMagick::VideoParser.new('youtube.com') }

        it { should_not be_valid }
      end
    end

    describe '#to_image' do
      it 'should return a file with video image' do
        video = MediaMagick::VideoParser.new('youtube.com/watch?v=FfUHkPf9D9k')

        video.to_image.should be_instance_of(File)
      end
    end

    describe '#to_html' do
      it 'should return video html' do
        video = MediaMagick::VideoParser.new('youtube.com/watch?v=FfUHkPf9D9k')

        video.to_html.should eq('<iframe width="560" height="315" src="http://www.youtube.com/embed/FfUHkPf9D9k" frameborder="0" allowfullscreen></iframe>')
      end
    end
  end

  describe 'vimeo' do
    describe 'valid?' do
      context 'with a valid url' do
        subject { MediaMagick::VideoParser.new('vimeo.com/44539044') }

        it { should be_valid }
      end

      context 'with a invalid url' do
        subject { MediaMagick::VideoParser.new('vimeo.com') }

        it { should_not be_valid }
      end
    end

    describe '#to_image' do
      it 'should return a file with video image' do
        video = MediaMagick::VideoParser.new('vimeo.com/44539044')

        video.to_image.should be_instance_of(File)
      end
    end

    describe '#to_html' do
      it 'should return video html' do
        video = MediaMagick::VideoParser.new('vimeo.com/44539044')

        video.to_html.should eq('<iframe src="http://player.vimeo.com/video/44539044?title=0&byline=0&portrait=0" width="500" height="341" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>')
      end
    end
  end
end
