class CreateArticlesPhotos < ActiveRecord::Migration
  def change
    create_table :articles_photos do |t|

      t.integer   :article_id, null: false, default: 0
      t.integer   :photo_id, null: false, default: 0

      t.timestamps null: false
    end

    add_index :articles_photos, [:article_id], name: 'idx_articles_photos_by_aid'
    add_index :articles_photos, [:photo_id], name: 'idx_articles_photos_by_pid'
  end
end
