require 'spec_helper'

describe MediaMagick::Controller::Helpers do
  let(:controller) { Class.new }

  before do
    controller.extend MediaMagick::Controller::Helpers
  end

  describe "getting doc by params" do
    let(:track) { Track.new }
    let!(:album) { Album.create(tracks: [track]) }

    context "document is embedded" do
      it "should get parent by params" do
        params = {
          :embedded_in_model => "album",
          :embedded_in_id    => "#{album.id.to_s}",
          :model             => "track",
          :model_id          => "#{track.id.to_s}"
        }
        controller.find_doc_by_params(params).should eq(track)
      end
    end

    context "document is root" do
      it "should get parent by params" do
        params = {
          :model             => "album",
          :model_id          => "#{album.id.to_s}"
        }
        controller.find_doc_by_params(params).should eq(album)
      end
    end
  end

  describe "creating video" do
    context "relation is attaches many" do
      let(:video_url) { "youtube.com/watch?v=FfUHkPf9D9k" }
      let!(:album) { Album.create }

      it "should create video" do
        params = {relation: "photos_and_videos", video: video_url}

        controller.create_video(album, params).should be_true
        album.reload.photos_and_videos.first.video.should eq(video_url)
      end
    end

    context "relation is attaches one" do
      let(:video_url) { "youtube.com/watch?v=FfUHkPf9D9k" }
      let!(:user) { User.create }

      it "should create video" do
        params = {relation: "photo_and_video", video: video_url}

        controller.create_video(user, params).should be_true
        user.reload.photo_and_video.video.should eq(video_url)
      end
    end
  end
end
