class AddStartedToTaskReport < ActiveRecord::Migration
  def change
  	add_column :task_reports, :started, :datetime
  end
end
