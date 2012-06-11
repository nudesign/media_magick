require 'spec_helper'

describe MediaMagick do
  describe ApplicationHelper do
    describe 'attachmentUploader' do
      it 'should create a div.attachmentUploader.photos' do
        album = Album.new
        album.stub(id: '12345678')

        helper.attachment_container(album, :photos) do
        end.should eq('<div class="attachmentUploader photos" data-id="12345678" data-model="Album" data-relation="photos" id="album-photos"></div>')
      end

      it 'should include partial option on data attributes' do
        album = Album.new
        album.stub(id: '12345678')

        helper.attachment_container(album, :photos, {}, {}, partial: 'albums/photo') do
        end.should eq('<div class="attachmentUploader photos" data-id="12345678" data-model="Album" data-partial="albums/photo" data-relation="photos" id="album-photos"></div>')
      end

      it 'should create a div.attachmentUploader.photos for embedded models' do
        album = Album.new
        album.stub(id: '12345678')

        track = album.tracks.new
        track.stub(id: '87654321')

        helper.attachment_container(track, :files, {}, {}, embedded_in: album) do
        end.should eq('<div class="attachmentUploader files" data-embedded-in-id="12345678" data-embedded-in-model="Album" data-id="87654321" data-model="Track" data-relation="files" id="track-files"></div>')
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
end
