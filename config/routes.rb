Rails.application.routes.draw do

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
    resources :questionnaires, only: [] do
      get 'questionnaire_list', on: :collection
      resource :answer, except: [:destroy]
    end
  end

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  scope '/admin' do
    resources :questionnaires, only: [:show, :create, :destroy, :index, :edit, :show] do
      post "ajax_form", on: :member
      get "update_status", on: :member
      resources :questions, only: [:create, :destroy]
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
