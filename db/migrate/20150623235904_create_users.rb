class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string    :login, null: false
      t.integer   :level, null: false, default: 0

      t.string    :salt
      t.string    :password
      t.string    :email

      t.timestamps null: false
    end
  end
end
