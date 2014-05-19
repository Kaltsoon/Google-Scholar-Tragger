class CreateScholarQueries < ActiveRecord::Migration
  def change
    create_table :scholar_queries do |t|
      t.timestamp :quering_time
      t.text :query_text
      t.timestamps
    end
  end
end
