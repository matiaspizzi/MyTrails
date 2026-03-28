Rails.application.routes.draw do
  # Authentication
  resource :registration, only: [ :new, :create ]
  resource :session, only: [ :new, :create, :destroy ]
  resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]

  # Objectives
  resources :objectives, only: [ :create, :update, :destroy ] do
    member do
      post :rate
      post :unrate
      get  :details
    end
  end

  # Users & account
  get   "account",         to: "users#account",        as: :account
  get   "users_roles",     to: "users#show_all",        as: :users_roles
  patch "users_roles/:id", to: "users#set_user_role",   as: :set_user_role
  resources :users, only: [] do
    member do
      patch  :update_profile_image
      delete :delete_profile_image
    end
  end

  # Dashboards
  get "leader_dashboard", to: "leaders#dashboard", as: :leader_dashboard
  get "admin_dashboard",  to: "admins#dashboard",  as: :admin_dashboard

  # Leaderships (admin only)
  resources :leaderships, only: [ :index, :create, :destroy ]

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
