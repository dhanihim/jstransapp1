class CustomerLocationPricelist < ApplicationRecord
	belongs_to :customer_location
	belongs_to :location
end
