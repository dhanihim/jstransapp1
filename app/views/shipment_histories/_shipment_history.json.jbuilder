json.extract! shipment_history, :id, :shipment_from_id, :shipment_to_id, :description, :created_at, :updated_at
json.url shipment_history_url(shipment_history, format: :json)
