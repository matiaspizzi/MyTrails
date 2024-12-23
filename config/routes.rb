Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  get 'confirm_registration', to: 'registrations#confirm'
  resource :registration, only: [:new, :create]
  resource :session
  resources :passwords, param: :token
  resources :objectives, only: [:index, :show, :create, :update, :destroy]


  get "pages/about"
  get "pages/authentification"
  get "pages/account"
  
  get 'account', to: 'users#account', as: :account
  get 'leader_dashboard', to: 'leader#dashboard', as: :leader_dashboard

  resources :users do
    member do
      patch :update_profile_image
      delete :delete_profile_image
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end