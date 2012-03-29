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
end