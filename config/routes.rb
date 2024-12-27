Rails.application.routes.draw do
  # mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
  # get 'confirm_registration', to: 'registrations#confirm'
  resource :registration, only: [:new, :create]
  resources :passwords, param: :token
  resources :objectives, only: [:create, :update, :destroy]


  get 'sign_in', to: 'sessions#new', as: :new_session
  post 'sign_in', to: 'sessions#create', as: :create_session
  delete 'sign_out', to: 'sessions#destroy', as: :destroy_session
  
  get 'account', to: 'users#account', as: :account
  resources :users do
    member do
      patch :update_profile_image
      delete :delete_profile_image
    end
  end
  
  post 'objective/rate', to: 'objectives#rate', as: :rate_objective
  get 'objective/:id', to: 'objectives#details', as: :objective_details

  get 'leader_dashboard', to: 'leaders#dashboard', as: :leader_dashboard
  
  get 'admin_dashboard', to: 'admins#dashboard', as: :admin_dashboard

  get 'users_roles', to: 'users#show_all', as: :users_roles

  patch 'users_roles.:id', to: 'users#set_user_role', as: :set_user_role

  get 'leadership', to: 'leaderships#show', as: :leadership
  post 'leadership', to: 'leaderships#create', as: :leadership_create
  delete 'leadership.:id', to: 'leaderships#destroy', as: :leadership_destroy


  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end