require 'spec_helper'

describe MediaMagick::Controller::Helpers do
  before do
    @controller = Class.new
    @controller.extend MediaMagick::Controller::Helpers
  end

  describe "getting doc by params" do
    before do
      @track = Track.new
      @album = Album.create(tracks: [@track])
    end

    context "document is embedded" do
      it "should get parent by params" do
        params = {
          :embedded_in_model => "album", 
          :embedded_in_id    => "#{@album.id.to_s}", 
          :model             => "track", 
          :model_id          => "#{@track.id.to_s}"
        }
        @controller.find_doc_by_params(params).should eq(@track)
      end
    end

    context "document is root" do
      it "should get parent by params" do
        params = {
          :model             => "album", 
          :model_id          => "#{@album.id.to_s}"
        }
        @controller.find_doc_by_params(params).should eq(@album)
      end
    end
  end
end