require 'spec_helper'

describe 'Images' do
  it 'should save the image on mongoid document' do
    album = Album.create
    album.photos.create(photo: File.new("#{File.expand_path('../..',  __FILE__)}/support/fixtures/nu.jpg"))
    
    album.reload.photos.first.photo.file.filename.should eq('nu.jpg')
  end
  
  it 'should save the file on mongoid document' do
    album = Album.create
    file = album.files.create(file: File.new("#{File.expand_path('../..',  __FILE__)}/support/fixtures/nu.txt"))
    
    album.reload.files.first.file.url.should eq("/uploads/album_files/file/#{file.id}/nu.txt")
  end

  it 'should access Uploader methods from relation class' do
    album = Album.create
    photo = album.photos.create(photo: File.new("#{File.expand_path('../..',  __FILE__)}/support/fixtures/nu.jpg"))

    photo.url.should eq("/uploads/album_photos/photo/#{photo.id}/nu.jpg")
  end
  
  it 'should access filename from relation class' do
    album = Album.create
    photo = album.photos.create(photo: File.new("#{File.expand_path('../..',  __FILE__)}/support/fixtures/nu.jpg"))

    album.reload.photos.first.filename.should eq('nu.jpg')
  end
end
