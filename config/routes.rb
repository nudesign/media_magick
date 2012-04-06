Rails.application.routes.draw do
  match 'upload' => 'media_magick/attach#create'
  match 'remove' => 'media_magick/attach#destroy'
  match 'update_priority' => 'media_magick/attach#update_priority'
  match 'recreate_versions' => 'media_magick/attach#recreate_versions', as: 'recreate_versions'
end
