class Location < ApplicationRecord
	has_many :customer_location
	has_many :customer_product_pricelist
end
