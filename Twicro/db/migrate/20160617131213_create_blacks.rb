class CreateBlacks < ActiveRecord::Migration
  def change
    create_table :blacks do |t|
      t.integer :temp_id
      t.integer :column
      t.integer :row

      t.timestamps null: false
    end
  end
end
