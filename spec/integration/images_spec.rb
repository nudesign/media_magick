require 'spec_helper'

describe 'Images' do
  it 'should save the image on mongoid document' do
    album = Album.create
    album.photos.create(photo: File.new("#{File.expand_path('../..',  __FILE__)}/support/fixtures/nu.jpg"))
    
    album.reload.photos.first.photo.file.filename.should eq('nu.jpg')
  end
end
