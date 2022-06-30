class Assignment < ApplicationRecord
	has_many :assignment_detail

	belongs_to :agent
	belongs_to :customer

end
