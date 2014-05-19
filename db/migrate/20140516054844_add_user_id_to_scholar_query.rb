class AddUserIdToScholarQuery < ActiveRecord::Migration
  def change
    add_column :scholar_queries, :user_id, :integer
  end
end
