Rails.application.routes.draw do

  get 'messages/create'

  get 'users/show'

  get 'companies_users/index'

  get 'conpanies_users/index'

  get 'companies/create'

  get 'admins/show'

  devise_for :admins, module: :admins
  devise_for :users, module: :users
  devise_scope :user do
    root :to => "users/sessions#new"
  end

  resources :admins, only: [:show]
  resources :companies, only: [:create] do

    resources :companies_users, only: [:index] do
      get 'changeManager', on: :member
      get 'registarManager', on: :member
    end
  end
  resources :users, only: [:show, :destroy] do
    get 'mypage', on: :member
    get 'manager', on: :member
    resources :messages, only: [:create, :destroy]
  end

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
