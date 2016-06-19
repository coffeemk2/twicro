class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :temp_id
      t.integer :no1
      t.integer :index1
      t.integer :no2
      t.integer :index2

      t.timestamps null: false
    end
  end
end
