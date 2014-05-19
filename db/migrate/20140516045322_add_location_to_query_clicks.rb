class AddLocationToQueryClicks < ActiveRecord::Migration
  def change
  	add_column :query_clicks, :location, :integer
  end
end
