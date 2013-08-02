# encoding: utf-8

require 'spec_helper'

describe MediaMagick::Model do
  describe 'including class methods' do
    before(:all) do
      @klass = User
    end

    it "should includes .attaches_many" do
      @klass.should respond_to(:attaches_many)
    end

    it "should includes .attaches_one" do
      @klass.should respond_to(:attaches_one)
    end
  end

  describe '.attaches_many' do
    before(:all) do
      @klass = Album
      @instance = @klass.new
    end

    it 'should create a "embeds_many" relationship with photos' do
      @klass.relations['photos'].relation.should eq(Mongoid::Relations::Embedded::Many)
    end

    it 'should create a relationship with photos through AlbumPhotos model' do
      @klass.relations['photos'].class_name.should eq('AlbumPhotos')
    end

    describe "naming relations" do
      it "transforms related compound name classes to camel case" do
        @instance.should respond_to(:compound_name_files)
        @instance.compound_name_files.build.class.should eq(AlbumCompoundNameFiles)
      end

      context "when model is inside a module" do
        it "creates the embedded class inside model scope" do
          product = Store::Product.new
          product.images.build.class.should eq(Store::ProductImages)
        end
      end
    end

    describe 'allow_videos' do
      let(:album) { Album.create }
      subject { album.photos_and_videos.create }

      it 'should include type field' do
        subject.fields.should include('type')
      end

      it 'should include video field' do
        subject.fields.should include('video')
      end

      it 'should accept youtube videos' do
        video = album.photos_and_videos.create(video: 'youtube.com/watch?v=FfUHkPf9D9k')

        video.type.should eq('video')

        video.url.should eq("/uploads/album_photos_and_videos/photos_and_video/#{video.id}/FfUHkPf9D9k.jpg")
        video.thumb.url.should eq("/uploads/album_photos_and_videos/photos_and_video/#{video.id}/thumb_FfUHkPf9D9k.jpg")
        video.source.should eq('<iframe width="560" height="315" src="http://www.youtube.com/embed/FfUHkPf9D9k" frameborder="0" allowfullscreen></iframe>')

        video.source(width: 156, height: 88).should eq('<iframe width="156" height="88" src="http://www.youtube.com/embed/FfUHkPf9D9k" frameborder="0" allowfullscreen></iframe>')
      end

      it 'should accept vimeo videos' do
        video = album.photos_and_videos.create(video: 'vimeo.com/43401461')

        video.type.should eq('video')

        video.url.should eq("/uploads/album_photos_and_videos/photos_and_video/#{video.id}/43401461.jpg")
        video.thumb.url.should eq("/uploads/album_photos_and_videos/photos_and_video/#{video.id}/thumb_43401461.jpg")
        video.source.should eq('<iframe src="http://player.vimeo.com/video/43401461?title=0&byline=0&portrait=0" width="500" height="341" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>')
        video.source(width: 156, height: 88).should eq('<iframe src="http://player.vimeo.com/video/43401461?title=0&byline=0&portrait=0" width="156" height="88" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>')
      end
    end

    describe '#photos' do
      subject { @instance.photos.new }

      it { should be_an_instance_of(AlbumPhotos) }

      it 'should perform a block in the context of the class' do
        @klass.attaches_many(:documents) do
          def test_method; end
        end

        @instance.documents.new.should respond_to(:test_method)
      end

      it "should be ordered by ascending priority" do
        @instance = @klass.create

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

            @klass.attaches_many :musics, uploader: AmazonS3Uploader
          end

          subject { @instance.musics.new }

          it { should respond_to(:music) }
          it { subject.music.should be_a_instance_of(AmazonS3Uploader) }
        end
      end

      context 'when user removes parent record' do

        it "should remove the pictures of the system" do
          %w[images photos files photos_and_videos pictures].each do |attaches|
            subject = @klass.create
            @image = subject.send(attaches).create(attaches.singularize => File.open("#{File.expand_path('../../..', __FILE__)}/support/fixtures/nu.jpg") )

            subject.destroy
            expect(File.directory?("#{Rails.root}/public/#{@image.store_dir}")).to be_false
          end
        end
      end
    end
  end

  describe '.attaches_one' do
    before(:all) do
      @klass    = User
      @instance = @klass.new
    end

    it 'should create an embedded model' do
      @klass.relations['photo'].class_name.should eq('UserPhoto')
    end

    it 'should create a "embeds_one" relation' do
      @klass.relations['photo'].relation.should eq(Mongoid::Relations::Embedded::One)
    end

    describe "naming relations" do
      it "should transform related compound name classe to camel case" do
        @instance.should respond_to(:compound_name_file)
        @instance.build_compound_name_file.class.should eq(UserCompoundNameFile)
      end
    end

    describe "related method" do
      subject { @instance.build_photo }

      it { should be_an_instance_of(UserPhoto) }

      it 'should perform a block in the context of the class' do
        @klass.attaches_one(:image) do
          def test_method; end
        end

        @instance.build_image.should respond_to(:test_method)
      end
    end

  end
end