# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sms/edit'
  get 'sms/create'
  get 'sms/confirm'
  get 'sms/check'
  match 'app_id', to: 'app_id#app_id', via: %i[get], as: 'app_id'  
  resources 'totp', only: %i[edit create destroy]
  resources 'fido', only: %i[edit create destroy]
  resources :sessions, only: %i[new create destroy]
  resources :users
  match 'totp/check', to: 'totp#check', via: %i[get post], as: 'check_totp'
  match 'fido/check/:id', to: 'fido#check', via: %i[get post], as: 'check_fido'

  root to: 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
