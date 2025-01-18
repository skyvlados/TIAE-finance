# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'
  resources :users
  resources :operations
  resources :categories
  delete '/operations_mass_delete' => 'operations#mass_delete', as: 'operations_mass_delete'
  get '/import_excel' => 'import_excel#new', as: 'new_import'
  post '/create_operations_from_excel' => 'import_excel#create', as: 'create_operations_from_excel'
end
