# encoding: utf-8

require 'spec_helper'

describe MediaMagick::Image::Dimensions do
  let!(:post) { Post.create }

  context "without image file" do
    describe "getting dimensions from original size" do
      it "should return width and height equal 0" do
        image = post.images.create
        image.size.should eq({width: 0, height: 0})
      end
    end

    describe "getting dimensions from thumb size" do
      it "should return width and height equal 0" do
        image = post.images.create
        image.thumb.size.should eq({width: 0, height: 0})
      end
    end
  end

  context "with image file" do
    describe "getting dimensions" do
      it "should return width and height of file" do
        file  = File.open(File.expand_path("../fixtures/example.jpg", Rails.root))
        image = post.images.create(image: file)

        image.size.should eq({width: 80, height: 50})
      end
    end
  end
end