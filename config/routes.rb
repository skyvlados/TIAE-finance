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
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
