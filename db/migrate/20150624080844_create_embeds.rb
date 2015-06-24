class CreateEmbeds < ActiveRecord::Migration
  def change
    create_table :embeds do |t|

      t.integer   :user_id
      t.integer   :article_id

      t.text      :source
      t.text      :code
      t.string    :cover
      t.string    :url

      t.string    :title
      t.text      :content
      t.text      :keywords

      t.string    :youtube_key
      t.string    :vimeo_key
      t.string    :fake_key

      t.timestamps null: false
    end

    add_index :embeds, [:user_id], name: 'idx_embeds_by_uid'
    add_index :embeds, [:article_id], name: 'idx_embeds_by_article_id'
  end
end
