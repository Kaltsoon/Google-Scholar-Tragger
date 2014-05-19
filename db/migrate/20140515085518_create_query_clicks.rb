class CreateQueryClicks < ActiveRecord::Migration
  def change
    create_table :query_clicks do |t|
      t.integer :scholar_query_id
      t.text :heading
      t.text :synopsis
      t.text :link_location
      t.integer :sitations
      t.timestamp :click_time
      t.timestamps
    end
  end
end
