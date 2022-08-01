class CustomerLocation < ApplicationRecord
	belongs_to :customer
	belongs_to :location

	has_many :customer_product_pricelist
	has_many :customer_location_pricelist
	has_many :assignment

	def name_with_initial
		"#{address}, #{Location.find(location_id).name}"
	end
end
