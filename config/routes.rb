Rails.application.routes.draw do
  post   'upload' => 'media_magick/attach#create'
  delete 'remove' => 'media_magick/attach#destroy'
  put    'update_priority' => 'media_magick/attach#update_priority'
  put    'recreate_versions' => 'media_magick/attach#recreate_versions', as: 'recreate_versions'
end
