Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :directories do
    get "files", to: "directories#index", as: :file_entries
    get "files/new", to: "directories#new_file", as: :new_file_entry
    post "files", to: "directories#create_file"
  end

  root "directories#index"
end
