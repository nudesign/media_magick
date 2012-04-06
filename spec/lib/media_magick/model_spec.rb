# encoding: utf-8

require 'spec_helper'

describe MediaMagick::Model do
  describe '.attachs_many' do
    before(:all) do
      @class = Album
      @instance = @class.new
    end

    it 'should create a "embeds_many" relationship with photos' do
      @class.relations['photos'].relation.should eq(Mongoid::Relations::Embedded::Many)
    end

    it 'should create a relationship with photos through AlbumPhotos model' do
      @class.relations['photos'].class_name.should eq('AlbumPhotos')
    end

    describe "naming relations" do
      it "should transform related compound name classes to camel case" do
        @instance.should respond_to(:compound_name_files)
        @instance.compound_name_files.build.class.should eq(AlbumCompoundNameFiles)
      end
    end

    describe '#photos' do
      subject { @instance.photos.new }

      it { should be_an_instance_of(AlbumPhotos) }

      it 'should perform a block in the context of the class' do
        @class.attachs_many(:documents) do
          def test_method
          end
        end

        @instance.documents.new.should respond_to(:test_method)
      end

      it "should be ordered by ascending priority" do
        @instance = @class.new

        photo2 = @instance.photos.create(priority: 1)
        photo1 = @instance.photos.create(priority: 0)

        @instance.reload.photos.should == [photo1, photo2]
      end

      it "should respond to priority" do
        subject.fields.include?(:priority)
      end

      it "should have priority 0 as default" do
        subject.priority.should be(0)
      end

      describe '#photo' do
        subject { @instance.photos.new.photo }

        it { should be_a_kind_of(CarrierWave::Uploader::Base) }

        describe 'custom_uploader' do
          before(:all) do
            class AmazonS3Uploader < CarrierWave::Uploader::Base
              storage :file
            end

            @class.attachs_many :musics, uploader: AmazonS3Uploader
          end

          subject { @instance.musics.new }

          it { should respond_to(:music) }
          it { subject.music.should be_a_instance_of(AmazonS3Uploader) }
        end
      end
    end
  end
end
