class AddEndClickToQueryClicks < ActiveRecord::Migration
  def change
  	add_column :query_clicks, :end_time, :datetime
  end
end