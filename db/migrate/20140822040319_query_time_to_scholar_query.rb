class QueryTimeToScholarQuery < ActiveRecord::Migration
  def change
  	add_column :scholar_queries, :query_time, :datetime
  end
end
