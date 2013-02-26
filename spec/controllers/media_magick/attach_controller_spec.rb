require 'spec_helper'

describe MediaMagick::AttachController do
  render_views

  describe "POST create" do
    describe "with valid params" do
      it "creates a new photo" do
        album = Album.create

        expect {
          post :create, { model: 'Album', id: album.id, relation: 'photos', file: fixture_file_upload("#{File.expand_path('../../..',  __FILE__)}/support/fixtures/nu.jpg") }
        }.to change { album.reload.photos.count }.by(1)

        response.should render_template('_image')
        response.body.should =~ /nu.jpg/m
      end

      it "creates a new photo for embedded models" do
        album = Album.create
        track = album.tracks.create

        expect {
          post :create, { embedded_in_id: album.id, embedded_in_model: 'Album', model: 'Track', id: track.id, relation: 'files', file: fixture_file_upload("#{File.expand_path('../../..',  __FILE__)}/support/fixtures/nu.jpg") }
        }.to change { track.reload.files.count }.by(1)

        response.should render_template('_image')
        response.body.should =~ /nu.jpg/m
      end

      it "render a personalized partial" do
        album = Album.create
        post :create, { model: 'Album', id: album.id, relation: 'photos', partial: 'albums/photo', file: fixture_file_upload("#{File.expand_path('../../..',  __FILE__)}/support/fixtures/nu.jpg") }
        response.should render_template('albums/_photo')
      end

      describe "creating videos" do
        context "relation is attaches many" do
          it "creates a new video" do
            album = Album.create

            expect {
              post :create, { model: 'Album', id: album.id, relation: 'photos_and_videos', video: 'youtube.com/watch?v=FfUHkPf9D9k' }
            }.to change { album.reload.photos_and_videos.count }.by(1)

            response.should render_template('_image')
            response.body.should =~ /FfUHkPf9D9k/m
          end
        end

        context "relation is attaches one" do
          it "creates a new video" do
            user      = User.create
            video_url = 'youtube.com/watch?v=FfUHkPf9D9k'

            post :create, { model: 'User', id: user.id, relation: 'photo_and_video', video: video_url }

            user.reload.photo_and_video.video.should eq(video_url)
            response.should render_template('_image')
            response.body.should =~ /FfUHkPf9D9k/m
          end
        end
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested photo" do
      album = Album.create
      photo = album.photos.create(photo: File.new(fixture_file_upload("#{File.expand_path('../../..',  __FILE__)}/support/fixtures/nu.jpg")))

      expect {
        delete :destroy, { model: 'Album', id: album.id, relation: 'photos', relation_id: photo.id }
      }.to change { album.reload.photos.count }.by(-1)
    end

    it "destroys the requested photo for embedded models" do
      album = Album.create
      track = album.tracks.create
      file = track.files.create(file: File.new(fixture_file_upload("#{File.expand_path('../../..',  __FILE__)}/support/fixtures/nu.jpg")))

      expect {
        delete :destroy, { embedded_in_model: 'Album', embedded_in_id: album.id, model: 'Track', id: track.id, relation: 'files', relation_id: file.id }
      }.to change { track.reload.files.count }.by(-1)
    end
  end

  describe "update priority" do
    it "updates the attachments priority" do
      album = Album.create
      photo1 = album.photos.create(photo: File.new(fixture_file_upload("#{File.expand_path('../../..',  __FILE__)}/support/fixtures/nu.jpg")))
      photo2 = album.photos.create(photo: File.new(fixture_file_upload("#{File.expand_path('../../..',  __FILE__)}/support/fixtures/nu.jpg")))

      id1 = photo1.id.to_s
      id2 = photo2.id.to_s

      put :update_priority, { elements: [id1, id2], model: 'Album', model_id: album.id.to_s, relation: 'photos' }

      photo1.reload.priority.should eq(0)
      photo2.reload.priority.should eq(1)
    end

    it "updates the attachments priority for embedded models" do
      album = Album.create
      track = album.tracks.create
      file1 = track.files.create(file: File.new(fixture_file_upload("#{File.expand_path('../../..',  __FILE__)}/support/fixtures/nu.jpg")))
      file2 = track.files.create(file: File.new(fixture_file_upload("#{File.expand_path('../../..',  __FILE__)}/support/fixtures/nu.jpg")))

      id1 = file1.id.to_s
      id2 = file2.id.to_s

      put :update_priority, { elements: [id1, id2], embedded_in_model: 'Album', embedded_in_id: album.id, model: 'Track', model_id: track.id.to_s, relation: 'files' }

      file1.reload.priority.should eq(0)
      file2.reload.priority.should eq(1)
    end
  end

  describe "recreate versions" do
    it "recreate images versions" do
      album = Album.create

      request.env["HTTP_REFERER"] = "/"
      put :recreate_versions, { model: 'album', model_id: album.id.to_s, relation: 'photos' }

      response.status.should be(302)
    end

    it "recreate images versions for embedded models" do
      album = Album.create
      track = album.tracks.create

      request.env["HTTP_REFERER"] = "/"
      put :recreate_versions, { embedded_in_model: 'album', embedded_in_id: album.id, model: 'track', model_id: track.id.to_s, relation: 'files' }

      response.status.should be(302)
    end
  end
end
