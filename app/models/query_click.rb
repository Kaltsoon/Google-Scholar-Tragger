class QueryClick < ActiveRecord::Base
	belongs_to :scholar_query

	def duration
		if end_time.nil?
			return "[No end time]"
		else
			return end_time - created_at
		end
	end
end
