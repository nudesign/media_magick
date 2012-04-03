require 'spec_helper'

describe MediaMagickHelper do
  describe 'attachmentUploader' do
    it 'should create a div.attachmentUploader.photos' do
      album = Album.new
      album.stub(id: '12345678')
      
      helper.attachment_container(album, :photos) do
      end.should eq('<div class="attachmentUploader photos" data-id="12345678" data-model="album" data-relation="photos" id="album-photos"></div>')
    end
  end
end