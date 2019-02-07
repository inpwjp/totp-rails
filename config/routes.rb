# frozen_string_literal: true

Rails.application.routes.draw do
  resources 'totp', only: %i[edit create destroy]
  resources :sessions, only: %i[new create destroy]
  resources :users
  match 'totp/check', to: 'totp#check', via: %i[get post], as: 'check_totp'

  root to: 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
