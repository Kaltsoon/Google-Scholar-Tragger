class AddFieldToTaskReports < ActiveRecord::Migration
  def change
  	add_column :task_reports, :items, :integer
  end
end
