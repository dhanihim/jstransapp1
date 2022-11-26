Rails.application.routes.draw do
  resources :assignment_updates
  resources :customer_location_pricelists
  
  resources :assignment_details

  resources :assignments do
    member do
      get :update_assignment_container
      get :remove_assignment_container
      get :document_invoice
      get :sync_assignment
    end
    collection do
      get :sync_all_assignment
      get :fetch_all_document
      get :duplicate
      get :price_adjustment
    end
  end

  resources :shipments do
    member do 
      get :document_dooring_list
      get :document_packing_list
      get :document_customer_packing_list
      get :document_record
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
  
  resources :customers do 
    member do 
      get :sync_customer
    end
    collection do
      get :sync_all_customer
    end
  end
  
  resources :agents do 
    member do 
      get :sync_agent
    end
    collection do
      get :sync_all_agent
    end
  end


  resources :locations

  root 'dashboard#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
