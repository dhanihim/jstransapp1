json.extract! shipment, :id, :uid, :shipname, :voyage, :estimateddeparture, :estimatedarrival, :actualdeparture, :actualarrival, :active, :description, :created_at, :updated_at
json.url shipment_url(shipment, format: :json)
