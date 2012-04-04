Rails.application.routes.draw do
  match 'upload' => 'attach#create'
  match 'remove' => 'attach#destroy'
  match 'update_priority' => 'attach#update_priority'
end
