# frozen_string_literal: true

Rails.application.routes.draw do
  # root 'welcome#index'
  root 'welcome#index'
  resources :users
  resources :operations
  resources :categories
  get '/confirm_email/:token', to: 'users#confirm_email', as: 'confirm_email'
  get 'login' => 'sessions#new'
  post '/login' => 'sessions#create'
  post '/send_confirm_email' => 'sessions#send_confirm_email', as: 'send_confirm_email'
  delete 'logout' => 'sessions#destroy'
  scope '/password' do
    get '/forgot', to: 'password_recovery#forgot_password', as: 'forgot_password'
    post '/recovery', to: 'password_recovery#password_recovery', as: 'password_recovery'
    get '/confirm_recovery/:token', to: 'password_recovery#set_new_password_form', as: 'set_new_password_form'
    post '/new', to: 'password_recovery#set_new_password', as: 'set_new_password'
  end
  get '/import_excel' => 'import_excel#create', as: 'create_operation_from_excel'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
