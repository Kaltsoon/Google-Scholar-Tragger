class AddTaskReportIdToScholarQuery < ActiveRecord::Migration
  def change
  	add_column :scholar_queries, :task_report_id, :integer
  end
end
