Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :directories, only: [:index]
  root "directories#index"
end
