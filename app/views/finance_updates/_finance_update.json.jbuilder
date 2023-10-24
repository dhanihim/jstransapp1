json.extract! finance_update, :id, :uid, :document_path, :description, :created_at, :updated_at
json.url finance_update_url(finance_update, format: :json)
