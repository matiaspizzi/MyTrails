Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  get 'confirm_registration', to: 'registrations#confirm'
  resource :registration, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token
  resources :objectives, only: [:create, :update, :destroy]

  post 'objective/rate', to: 'objectives#rate', as: :rate_objective

  get 'objective/:id', to: 'objectives#details', as: :objective_details

  get 'pages/account'
  
  get 'account', to: 'users#account', as: :account

  get 'leader_dashboard', to: 'leaders#dashboard', as: :leader_dashboard

  get 'admin_dashboard', to: 'admins#dashboard', as: :admin_dashboard

  get 'leadership', to: 'leaderships#show', as: :leadership

  post 'leadership', to: 'leaderships#create', as: :leadership_create

  delete 'leadership.:id', to: 'leaderships#destroy', as: :leadership_destroy

  resources :users do
    member do
      patch :update_profile_image
      delete :delete_profile_image
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end