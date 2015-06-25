class AddColumnHitsCountToArticles < ActiveRecord::Migration

  def change
    add_column :articles, :hits_count, :integer, null: false, default: 0
  end

end
