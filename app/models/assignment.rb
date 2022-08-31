class Assignment < ApplicationRecord
	has_many :assignment_detail

	belongs_to :agent
	belongs_to :customer

	mount_uploader :document_status, FileUploader
	mount_uploader :payment_status, FileUploader
	mount_uploader :dooring_status, FileUploader
end
