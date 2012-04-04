require 'spec_helper'

describe MediaMagickHelper do
  describe 'attachmentUploader' do
    it 'should create a div.attachmentUploader.photos' do
      album = Album.new
      album.stub(id: '12345678')

      helper.attachment_container(album, :photos) do
      end.should eq('<div class="attachmentUploader photos" data-id="12345678" data-model="album" data-relation="photos" id="album-photos"></div>')
    end

    it 'should renders default partial if block is not given' do
      photo = AlbumPhotos.new
      photo.stub(filename: 'photo.jpg', url: 'url/photo.jpg')

      file = AlbumFiles.new
      file.stub(filename: 'file.pdf', url: 'url/file.pdf')

      album = Album.new(photos: [photo], files: [file])
      album.stub(id: '12345678')

      helper.attachment_container(album, :photos).should match(/url\/photo.jpg/)
      helper.attachment_container(album, :files).should match(/url\/file.pdf/)
    end
  end
end