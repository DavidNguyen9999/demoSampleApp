Rails.application.routes.draw do
  get 'notifications/index'
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', edit: 'edit', confirmation: 'confirmations' },
                                            controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  #get "password_resets/new"
  #get "password_resets/edit"
  #get "sessions/new"
  #get "users/new"
  #get "/signup", to: "users#new"
  #get "/login", to: "sessions#new"
  #post "/login", to: "sessions#create"
  #delete "/logout", to: "sessions#destroy"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/home", to: "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  root "static_pages#home"
  resources :users do
    member do
      get :following, :followers
    end
  end
  #resources :account_activations, only: [:edit]
  #resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :comments, only: [:index, :create, :destroy]
  resources :comments do
    member do
      put "like", to: "comments#like"
      put "dislike", to: "comments#dislike"
    end
  end
  mount ActionCable.server => '/cable'
  resources :notifications
  resources :export_csv, only: %i[index]
end
