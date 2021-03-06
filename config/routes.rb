# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  post '/' => 'conversations#ajax_sum'

  resources :conversations, only: [:create] do
    member do
      post :close
    end
  end
end
