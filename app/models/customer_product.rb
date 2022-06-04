class CustomerProduct < ApplicationRecord
	belongs_to :customer

	has_many :customer_product_pricelist
end
