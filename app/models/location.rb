class Location < ApplicationRecord
	has_many :customer_location
	has_many :customer_product_pricelist
	has_many :customer_location_pricelist
end
