class AddColumnsToTask < ActiveRecord::Migration
  def change
  	add_column :tasks, :title, :text
  	add_column :tasks, :task_type, :text
  end
end
