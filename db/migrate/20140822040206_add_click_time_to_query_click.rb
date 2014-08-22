class AddClickTimeToQueryClick < ActiveRecord::Migration
  def change
  	add_column :query_clicks, :click_time, :datetime
  end
end
