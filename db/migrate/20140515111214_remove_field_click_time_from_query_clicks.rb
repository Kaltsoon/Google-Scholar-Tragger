class RemoveFieldClickTimeFromQueryClicks < ActiveRecord::Migration
  def change
    remove_column :query_clicks, :click_time, :timestamp
  end
end
