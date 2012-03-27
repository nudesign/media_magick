Rails.application.routes.draw do
  match 'upload' => 'attach#create'
  match 'remove' => 'attach#destroy'
end
