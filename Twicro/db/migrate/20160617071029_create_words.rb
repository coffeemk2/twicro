class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.integer :uid
      t.string :surface
      t.string :kana
      t.integer :length
      t.boolean :is_used
      t.integer :tweet_id , :limit => 8

      t.timestamps null: false
    end
  end
end
