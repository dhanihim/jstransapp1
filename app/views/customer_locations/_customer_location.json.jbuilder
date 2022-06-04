json.extract! customer_location, :id, :address, :active, :description, :created_at, :updated_at
json.url customer_location_url(customer_location, format: :json)
