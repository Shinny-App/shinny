Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :registration, only: %i[new create]

  resource :dashboard, only: :show, controller: "dashboard"

  resources :games, only: :show do
    resource :rsvp, only: %i[create update]
    resource :score, only: :update, controller: "scores"
  end

  resources :leagues, only: [] do
    get :standings, on: :member
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#show"
end
