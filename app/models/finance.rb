class Finance < ApplicationRecord
	mount_uploader :payment_document, FileUploader

	def self.internet_connection
	  begin
	    true if open("http://jstranslogistik.com/")
	  rescue
	    false
	  end
	end
end
