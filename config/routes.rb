Rails.application.routes.draw do
  resources :assignment_details
  resources :assignments
  resources :shipments
  resources :customer_product_pricelists
  resources :containers
  devise_for :users
  get 'dashboard/index'
  resources :customer_products
  resources :customer_locations
  resources :customers
  resources :agents
  resources :locations

  root 'dashboard#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
