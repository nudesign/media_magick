require 'spec_helper'

describe AttachController, :type => :controller do
  render_views
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new photo" do
        album = Album.create
        
        expect {
          post :create, { model: 'album', id: album.id, relation: 'photos', file: fixture_file_upload("#{File.expand_path('../..',  __FILE__)}/support/fixtures/nu.jpg") }
        }.to change { album.reload.photos.count }.by(1)
        
        response.should render_template('_image')
        
        response.body.should =~ /nu.jpg/m
      end
    end
  end
  
  describe "DELETE destroy" do
    it "destroys the requested photo" do
      album = Album.create
      photo = album.photos.create(photo: File.new(fixture_file_upload("#{File.expand_path('../..',  __FILE__)}/support/fixtures/nu.jpg")))
      
      expect {
        delete :destroy, { model: 'album', id: album.id, relation: 'photos', relation_id: photo.id }
      }.to change { album.reload.photos.count }.by(-1)
    end
  end
  
  describe "update priority" do
    it "updates the attachments priority" do
      album = Album.create
      photo1 = album.photos.create(photo: File.new(fixture_file_upload("#{File.expand_path('../..',  __FILE__)}/support/fixtures/nu.jpg")))
      photo2 = album.photos.create(photo: File.new(fixture_file_upload("#{File.expand_path('../..',  __FILE__)}/support/fixtures/nu.jpg")))
      
      id1 = photo1.id.to_s
      id2 = photo2.id.to_s
      
      put :update_priority, { elements: [id1, id2], model: 'album', model_id: album.id.to_s, relation: 'photos' }
      
      photo1.reload.priority.should eq(0)
      photo2.reload.priority.should eq(1)
    end  
  end

  describe "recriate versions" do
    it "recriate images versions" do
      album = Album.create
      
      put :recreate_versions, { model: 'album', model_id: album.id.to_s, relation: 'photos' }

      response.status.should be(200)
    end  
  end
end