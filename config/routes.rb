Rails.application.routes.draw do
  resources :customer_location_pricelists
  
  resources :assignment_details

  resources :assignments do
    member do
      get :update_assignment_container
      get :remove_assignment_container
      get :document_invoice
    end
  end

  resources :shipments do
    member do 
      get :document_packing_list
      get :depart
    end
  end

  resources :customer_product_pricelists
  
  resources :containers do
    member do 
      get :update_container_shipment
    end
  end

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
