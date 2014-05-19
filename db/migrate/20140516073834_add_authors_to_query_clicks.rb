class AddAuthorsToQueryClicks < ActiveRecord::Migration
  def change
    add_column :query_clicks, :authors, :text
  end
end
