class CreateTaskReports < ActiveRecord::Migration
  def change
    create_table :task_reports do |t|
      t.integer :task_id
      t.integer :scholar_query_id
      t.text :report

      t.timestamps
    end
  end
end
