class AssignmentDetail < ApplicationRecord
	belongs_to :assignment
	belongs_to :customer_product 
end
