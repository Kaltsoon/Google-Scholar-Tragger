class TaskReport < ActiveRecord::Base
	has_many :scholar_queries, dependent: :destroy
	belongs_to :task
	belongs_to :user

	validates :task_id, uniqueness: { scope: :user_id }

	def duration
		if completed.nil?
			return "[Not completed]"
		else
			return completed - ( started || created_at )
		end
	end
end
