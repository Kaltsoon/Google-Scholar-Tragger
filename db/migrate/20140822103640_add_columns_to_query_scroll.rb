class AddColumnsToQueryScroll < ActiveRecord::Migration
  def change
  	add_column :query_scrolls, :start_position, :integer
  	add_column :query_scrolls, :end_position, :integer
  	add_column :query_scrolls, :start_time, :datetime
  	add_column :query_scrolls, :end_time, :datetime
  end
end
