# frozen_string_literal: true

Rails.application.routes.draw do
  # root 'welcome#index'
  root 'welcome#index'
  resources :users
  resources :operations
  resources :categories
  get '/confirm_email/:token', to: 'users#confirm_email', as: 'confirm_email'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  post 'send_confirm_email' => 'sessions#send_confirm_email', as: 'send_confirm_email'
  delete 'logout' => 'sessions#destroy'
  scope '/password' do
    get '/forgot_password', to: 'password_recovery#forgot_password'
    post 'password_recovery', to: 'password_recovery#password_recovery'
    get '/confirm_recovery_password/:token', to: 'password_recovery#set_new_password_form', as: 'set_new_password_form'
    post 'set_new_password', to: 'password_recovery#set_new_password'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
