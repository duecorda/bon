class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|

      t.integer   :user_id
      t.integer   :article_id

      t.string    :hashkey

      t.string    :original_filename
      t.string    :filename
      t.string    :content_type
      t.string    :filesize
      t.string    :dimensions
      t.string    :positions
      t.string    :details

      t.string    :title
      t.text      :content
      t.text      :keywords
      t.text      :colors

      t.timestamps null: false
    end

    add_index :photos, [:user_id], name: 'idx_photos_by_uid'
    add_index :photos, [:article_id], name: 'idx_photos_by_article_id'
  end
end
