class Customer < ApplicationRecord
	has_many :customer_location
	has_many :customer_product
	has_many :assignment
end
