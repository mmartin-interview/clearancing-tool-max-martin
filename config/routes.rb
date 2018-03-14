Rails.application.routes.draw do

  root to: "clearance_batches#index"
  resources :clearance_batches, only: [:index, :create, :new, :show]
end
