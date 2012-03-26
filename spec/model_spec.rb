# encoding: utf-8

require 'spec_helper'

describe MediaMagick::Model do
  describe '.attach_many' do
    before(:all) do
      class Album
      end
      
      @class = Album
      @class.send(:include, Mongoid::Document)
      @class.send(:include, MediaMagick::Model)
      @class.attach_many(:photos)
      @instance = @class.new
    end
    
    it 'should create a "embeds_many" relationship with photos' do
      @class.relations['photos'].relation.should eq(Mongoid::Relations::Embedded::Many)
    end
    
    it 'should create a relationship with photos through AlbumPhotos model' do
      @class.relations['photos'].class_name.should eq('AlbumPhotos')
    end
    
    describe '#photos' do
      subject { @instance.photos.new }
      
      it { should be_an_instance_of(AlbumPhotos) }
      
      it 'should perform a block in the context of the class' do
        @class.attach_many(:files) do
          def test_method
          end
        end
        
        @instance.files.new.should respond_to(:test_method)
      end
      
      describe '#photo' do
        subject { @instance.photos.new.photo }
        
        it { should be_a_kind_of(CarrierWave::Uploader::Base) }
      end
    end
  end
end