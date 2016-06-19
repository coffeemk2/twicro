class CreateWhites < ActiveRecord::Migration
  def change
    create_table :whites do |t|
      t.integer :temp_id
      t.integer :no
      t.integer :column
      t.integer :row
      t.integer :length
      t.boolean :horizonal

      t.timestamps null: false
    end
  end
end
