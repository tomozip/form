Rails.application.routes.draw do

  get 'admins/show'

  devise_for :admins, module: :admins
  devise_for :users, module: :users
  devise_scope :user do
    root :to => "users/sessions#new"
  end

  resources :admins, only: [:show]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
