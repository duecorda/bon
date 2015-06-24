class CreateArticlesTags < ActiveRecord::Migration
  def change
    create_table :articles_tags do |t|

      t.integer   :article_id, null: false, default: 0
      t.integer   :tag_id, null: false, default: 0

      t.timestamps null: false
    end

    add_index :articles_tags, [:article_id], name: 'idx_articles_tags_by_aid'
    add_index :articles_tags, [:tag_id], name: 'idx_articles_tags_by_tid'
  end
end
