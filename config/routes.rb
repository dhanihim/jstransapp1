Rails.application.routes.draw do
  resources :finance_updates
  resources :shipment_histories
  resources :finances do
    member do
      get :document_invoice
      get :undo_payment
    end
    collection do 
      get :fetch_all_document
      get :sync_all
      get :sync
      get :attach_assignment
      get :remove_assignment
      get :document_tax_report
    end
  end
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
      get :document_invoice
      get :depart
    end
    collection do 
      get :rename
      get :merge
      get :merge_action
      get :update_container_shipment
      get :remove_container_shipment
    end
  end

  resources :customer_product_pricelists
  
  resources :containers do
    member do 
      get :update_container_shipment
    end
  end

  match '/users',   to: 'users#index',   via: 'get'
  #match '/users/:id',     to: 'users#show',       via: 'get'
  
  devise_for :users, :path_prefix => 'd'
  resources :users do 
    collection do 
      get :create_user
    end
    member do
      get :delete_user
    end
  end
  
  get 'dashboard/index'
  get 'dashboard/unpaid_assignment_list'

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
