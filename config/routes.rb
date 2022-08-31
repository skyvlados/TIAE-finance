# frozen_string_literal: true

Rails.application.routes.draw do
  # root 'welcome#index'
  root 'welcome#index'
  resources :users do
    member do
      get :confirm_email
    end
  end
  resources :operations
  resources :categories
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
