class AddUserIdAndTaskIdToTaskReport < ActiveRecord::Migration
  def change
  	add_column :task_reports, :user_id, :integer
  end
end
