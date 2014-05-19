class ScholarQuery < ActiveRecord::Base
	has_many :query_clicks, dependent: :destroy
	belongs_to :user

	validates :query_text, presence: true
	validates :user_id, presence: true

	def broadness_str
		if broadness.nil?
			return "[No feedback]"
		end

		options = [];
		options[1] = "Too broad"
		options[2] = "Intermediate"
		options[3] = "Too narrow"

		return options[broadness]
	end

	def satisfaction_str
		if satisfaction.nil?
			return "[No feedback]"
		end

		options = [];
		options[1] = "Totally dis-satisfactory"
		options[2] = "Dis-satisfactory"
		options[3] = "Satisfactory"
		options[4] = "Very satisfactory"

		return options[satisfaction]
	end
end
