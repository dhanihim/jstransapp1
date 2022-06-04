class CustomerProductPricelist < ApplicationRecord
	belongs_to :customer_product
	belongs_to :customer_location
	belongs_to :location
end
