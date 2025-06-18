Rails.application.routes.draw do
  root "todos#index"
  resources :brags, only: [:index]
  get "brags/index"
  resources :todos do
    member do
      patch :toggle_done
    end
  end
end