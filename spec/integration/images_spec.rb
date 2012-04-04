require 'spec_helper'

describe 'Images' do
  let(:image_file)     { File.new("#{File.expand_path('../..',  __FILE__)}/support/fixtures/nu.jpg") }
  let(:non_image_file) { File.new("#{File.expand_path('../..',  __FILE__)}/support/fixtures/nu.txt") }

  it 'should save the image on mongoid document' do
    product = Product.create
    product.images.create(image: image_file)

    product.reload.images.first.filename.should eq('nu.jpg')
  end

  it 'should save the file on mongoid document' do
    product = Product.create
    file = product.files.create(file: non_image_file)

    product.reload.files.first.url.should eq("/uploads/product_files/file/#{file.id}/nu.txt")
  end

  it 'should access Uploader methods from relation class' do
    product = Product.create
    image = product.images.create(image: image_file)

    image.url.should eq("/uploads/product_images/image/#{image.id}/nu.jpg")
  end

  it 'should access filename from relation class' do
    product = Product.create
    product.images.create(image: image_file)

    product.reload.images.first.filename.should eq('nu.jpg')
  end

  it 'should add fields on relation class' do
    product = Product.create
    product.images.create(image: image_file, tags: ['ruby', 'guru'])

    product.reload.images.first.tags.should eq(['ruby', 'guru'])
  end

  it 'should create version of images' do
    product = Product.create
    image = product.images.create(image: image_file)
    product.reload.images.first.thumb.url.should eq("/uploads/product_images/image/#{image.id}/thumb_nu.jpg")
  end
end
