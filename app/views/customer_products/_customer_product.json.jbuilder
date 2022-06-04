json.extract! customer_product, :id, :name, :uom, :active, :description, :created_at, :updated_at
json.url customer_product_url(customer_product, format: :json)
