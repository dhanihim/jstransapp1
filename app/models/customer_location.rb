class CustomerLocation < ApplicationRecord
	belongs_to :customer
	belongs_to :location

	has_many :customer_product_pricelist
end
