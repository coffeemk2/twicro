class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :tweet_id ,:limit => 8
      t.string :text

      t.timestamps null: false
    end
  end
end
