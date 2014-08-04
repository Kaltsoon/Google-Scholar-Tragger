class Task < ActiveRecord::Base
	has_many :task_reports, dependent: :destroy

	validates :description, presence: true
end
