class Finance < ApplicationRecord
	mount_uploader :payment_document, FileUploader
end
