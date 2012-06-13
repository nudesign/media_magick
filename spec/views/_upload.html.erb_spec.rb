require 'spec_helper'

describe '_upload' do
  let(:album)             { stub_model(Album) }
  let(:album_with_photos) { stub_model(Album, photos: [stub_model(AlbumPhotos)]) }
  let(:album_with_files)  { stub_model(Album, files: [stub_model(AlbumFiles)]) }

  def default_attributes
    { newAttachments: {}, loadedAttachments: {}, partial: nil, model: album, relations: 'photos' }
  end

  it 'should personalize css classes attributes of newAttachments element' do
    render 'upload', default_attributes.merge(newAttachments: { class: 'thumbnails' })
    rendered.should =~ /<div class="newAttachments thumbnails">/
  end

  it 'should personalize css classes attributes of loadedAttachments element' do
    render 'upload', default_attributes.merge(loadedAttachments: { class: 'span3' })
    rendered.should =~ /<ul class="loadedAttachments span3">/
  end

  it 'should render image partial when attach is a image' do
    stub_template '_image' => 'image partial'
    render 'upload', default_attributes.merge(model: album_with_photos)
    rendered.should =~ /image partial/
  end

  it 'should render image partial when attach is a file' do
    stub_template '_file' => 'file partial'
    render 'upload', default_attributes.merge(model: album_with_files, relations: 'files')
    rendered.should =~ /file partial/
  end

  it 'should render the partial passed' do
    stub_template 'albums/_photo' => 'my partial'
    render 'upload', default_attributes.merge(model: album_with_photos, partial: 'albums/photo')
    rendered.should =~ /my partial/
  end
end
