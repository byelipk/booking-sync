Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :bookings, only: [:index]
      resources :rentals, only: [:index, :show, :update]
    end
  end
end
