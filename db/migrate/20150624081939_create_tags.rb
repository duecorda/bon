class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|

      t.string    :name
      t.integer   :weight, null: false, default: 0

      t.timestamps null: false
    end

    add_index :tags, [:name], name: 'idx_tags_by_nme'
    add_index :tags, [:weight], name: 'idx_tags_by_wgt'
  end
end
