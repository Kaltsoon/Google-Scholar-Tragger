class AddTimeToQueryScroll < ActiveRecord::Migration
  def change
  	add_column :query_scrolls, :scroll_time, :timestamp
  end
end
