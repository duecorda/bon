class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|

      t.integer   :user_id
      t.string    :title
      t.text      :content
      t.text      :keywords
      t.text      :hashtags

      t.integer   :state

      t.datetime  :published_at
      t.integer   :published, null: false, default: 0

      t.integer   :comments_count, null: false, default: 0
      t.integer   :recommended, null: false, default: 0

      t.timestamps null: false
    end

    add_index :articles, [:user_id, :published, :published_at], name: "idx_articles_by_upp"
    add_index :articles, [:published, :published_at], name: "idx_articles_by_pp"
    add_index :articles, [:published, :recommended], name: "idx_articles_by_pr"
    add_index :articles, [:published, :comments_count], name: "idx_articles_by_pc"
  end
end
