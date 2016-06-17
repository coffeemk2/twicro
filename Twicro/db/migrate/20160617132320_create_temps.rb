class CreateTemps < ActiveRecord::Migration
  def change
    create_table :temps do |t|
      t.integer :height
      t.integer :width

      t.timestamps null: false
    end
  end
end
