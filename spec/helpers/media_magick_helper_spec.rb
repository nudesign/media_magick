require 'spec_helper'

describe MediaMagickHelper do
  describe 'attachmentUploader' do
    it 'should create a div.attachmentUploader' do
      album = Album.new
      album.stub(id: '12345678')
      
      helper.attachment_container(album, :photos) do
      end.should eq('<div class="attachmentUploader" data-id="12345678" data-model="album" data-relation="photos" id="album-photos"></div>')
    end
  end
  
  describe 'attachment_item' do
    it 'should create a attachment_item' do
      album = Album.new
      album.stub(id: '12345678')
      
      helper.attachment_item(:div, album, class: 'album').should eq('<div class="album attachment" data-id="12345678"></div>')
    end
  end
end