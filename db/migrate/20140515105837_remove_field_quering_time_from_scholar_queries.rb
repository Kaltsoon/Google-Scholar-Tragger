class RemoveFieldQueringTimeFromScholarQueries < ActiveRecord::Migration
  def change
    remove_column :scholar_queries, :quering_time, :timestamp
  end
end
