class CreateQueryScrolls < ActiveRecord::Migration
  def change
    create_table :query_scrolls do |t|
      t.integer :scholar_query_id
      t.integer :location

      t.timestamps
    end
  end
end
