Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :bookings, only: [:index, :show, :update, :create, :destroy]
      resources :rentals, only: [:index, :show, :update, :create, :destroy]
    end
  end
end
