class AddSatisfactionToScholarQuery < ActiveRecord::Migration
  def change
    add_column :scholar_queries, :satisfaction, :integer
  end
end
