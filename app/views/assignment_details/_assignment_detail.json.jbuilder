json.extract! assignment_detail, :id, :quantity, :total, :created_at, :updated_at
json.url assignment_detail_url(assignment_detail, format: :json)
