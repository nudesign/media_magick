require 'spec_helper'

describe 'routes for Attach' do
  it 'routes /upload to create action' do
    post('/upload').should route_to('media_magick/attach#create')
  end

  it 'routes /remove to destroy action' do
    delete('/remove').should route_to('media_magick/attach#destroy')
  end

  it 'routes /update_priority to update_priority action' do
    put('/update_priority').should route_to('media_magick/attach#update_priority')
  end

  it 'routes /recreate_versions to recreate_versions action' do
    put('/recreate_versions').should route_to('media_magick/attach#recreate_versions')
  end

  it 'routes recreate_versions_path to recreate_versions action' do
    put(recreate_versions_path).should route_to('media_magick/attach#recreate_versions')
  end

end
