json.extract! customer, :id, :name, :address, :contact, :active, :description, :created_at, :updated_at
json.url customer_url(customer, format: :json)
