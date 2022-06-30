class CustomerProduct < ApplicationRecord
	belongs_to :customer

	has_many :customer_product_pricelist
	has_many :assignment_detail
end
