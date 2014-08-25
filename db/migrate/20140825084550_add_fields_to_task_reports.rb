class AddFieldsToTaskReports < ActiveRecord::Migration
  def change
  	add_column :task_reports, :item_height, :integer
  	add_column :task_reports, :form_height, :integer
  end
end
