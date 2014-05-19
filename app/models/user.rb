class User < ActiveRecord::Base
	has_many :scholar_queries, dependent: :destroy
	validates :name, uniqueness: true, presence: true

	def get_url
		return "localhost:3000/search/#{token}"
	end
end
