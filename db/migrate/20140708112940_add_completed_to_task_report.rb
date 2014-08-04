class AddCompletedToTaskReport < ActiveRecord::Migration
  def change
  	add_column :task_reports, :completed, :timestamp
  end
end
