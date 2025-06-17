Rails.application.routes.draw do
  resources :brags, only: [:index]
  get "brags/index"
  resources :todos do
    member do
      patch :toggle_done
    end
  end
end