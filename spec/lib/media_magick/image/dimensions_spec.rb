# encoding: utf-8

require 'spec_helper'

describe MediaMagick::Image::Dimensions do
  let!(:post) { Post.create }

  context "without image file" do
    describe "getting dimensions from original size" do
      it "should return width and height equal 0" do
        image = post.images.create
        image.size.should eq({"width" => 0, "height" => 0})
      end
    end

    describe "getting dimensions from thumb size" do
      it "should return width and height equal 0" do
        image = post.images.create
        image.thumb.size.should eq({"width" => 0, "height" => 0})
      end
    end
  end

  context "with image file" do
    describe "getting dimensions" do
      let(:file) { File.open(File.expand_path("../fixtures/example.jpg", Rails.root)) }
      let!(:image) { post.images.create(image: file) }
      let(:sizes) {
        { "_original" => {"width" => 960, "height" => 544},
          "thumb"     => {"width" => 240, "height" => 136},
          "big"       => {"width" => 863, "height" => 489}
        }
      }

      it "should return width and height of file" do
        image.size.should eq(sizes["_original"])
      end

      describe "versions" do
        it "should return width and height for thumb version" do
          image.thumb.size.should eq(sizes["thumb"])
        end

        it "should return width and height for big version" do
          image.big.size.should eq(sizes["big"])
        end

        describe "persistence" do
          before do
            image.size
            image.thumb.size
            image.big.size
          end

          it "should store dimenions for all versions" do
            image.dimensions.should eq(sizes)
          end
        end
      end
    end
  end
end
