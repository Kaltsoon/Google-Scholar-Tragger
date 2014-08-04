class TaskReport < ActiveRecord::Base
	has_many :scholar_queries, dependent: :destroy
	belongs_to :task
	belongs_to :user

	validates :task_id, uniqueness: { scope: :user_id }

	def duration
		if completed.nil?
			return "[Not completed]"
		else
			return "#{((completed - created_at) / 60).round(2)} min"
		end
	end
end
