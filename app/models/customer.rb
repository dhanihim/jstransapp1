class Customer < ApplicationRecord
	has_many :customer_location
	has_many :customer_product
	has_many :assignment

	mount_uploader :npwp_file, FileUploader
	mount_uploader :person_responsible_file, FileUploader
end
