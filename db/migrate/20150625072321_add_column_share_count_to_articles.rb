class AddColumnShareCountToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :share_count_fb, :integer, null: false, default: 0
    add_column :articles, :share_count_tw, :integer, null: false, default: 0
  end
end
