# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'
  # get '/users', to: 'users#index'
  # get '/users/:id', to: 'users#show'
  # get '/users/new', to: 'users#new'
  # post '/users', to: 'users#create'
  resources :users
  resources :operations
  resources :categories
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
