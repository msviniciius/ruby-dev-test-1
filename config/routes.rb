Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :directories do
    resources :file_entries, only: [:index, :new, :create]
  end

  root 'directories#index'
end
