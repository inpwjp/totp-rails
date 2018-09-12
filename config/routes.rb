Rails.application.routes.draw do
  resources 'totp', only:[:edit, :create, :destroy]
  resources :sessions ,only: [:new, :create, :destroy]
  resources :users
  match 'totp/check', to: 'totp#check', via: [:get, :post], as: 'check_totp'

  root to: 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
