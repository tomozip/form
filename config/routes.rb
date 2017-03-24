Rails.application.routes.draw do

  get 'companies/create'

  get 'admins/show'

  devise_for :admins, module: :admins
  devise_for :users, module: :users
  devise_scope :user do
    root :to => "users/sessions#new"
  end

  resources :admins, only: [:show]
  resources :companies, only: [:create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
