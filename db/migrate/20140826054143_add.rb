class Add < ActiveRecord::Migration
  def change
  	add_column :tasks, :task_code, :text
  end
end
