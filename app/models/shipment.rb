class Shipment < ApplicationRecord
	def shipname_with_uid
		"#{uid} - #{shipname} #{voyage} - #{Location.find(pol).name} -> #{Location.find(pod).name}, Departure #{estimateddeparture.to_s(:long)}"
	end
end
