class AddBroadnessToScholarQuery < ActiveRecord::Migration
  def change
    add_column :scholar_queries, :broadness, :integer
  end
end
