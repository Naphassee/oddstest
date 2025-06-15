Rails.application.routes.draw do
  resources :todos do
    member do
      patch :toggle_done
    end
  end
end