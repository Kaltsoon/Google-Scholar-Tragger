class User < ActiveRecord::Base
	has_many :task_reports, dependent: :destroy
	has_many :scholar_queries, dependent: :destroy
	
	validates :name, uniqueness: true, presence: true

	def get_url
		return "/search/#{token}"
	end
end
