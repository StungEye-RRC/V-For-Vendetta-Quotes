# frozen_string_literal: true

Rails.application.routes.draw do
  resources :quotes

  root to: 'home#index'
end
