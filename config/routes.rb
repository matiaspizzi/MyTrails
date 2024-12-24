Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  get 'confirm_registration', to: 'registrations#confirm'
  resource :registration, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token
  resources :objectives, only: [:index, :show, :create, :update, :destroy]

  post '/objectives/rate', to: 'objectives#rate', as: 'rate_objective'

  get "pages/about"
  get "pages/account"
  
  get 'account', to: 'users#account', as: :account
  get 'leader_dashboard', to: 'leader#dashboard', as: :leader_dashboard
  get 'leader/objective/:id', to: 'leader#objective', as: :leader_objective

  resources :users do
    member do
      patch :update_profile_image
      delete :delete_profile_image
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end