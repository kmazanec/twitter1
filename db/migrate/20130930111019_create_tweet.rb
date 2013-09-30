class CreateTweet < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :tweet_id, limit: 8
      t.string :text
      t.integer :twitter_user_id
      t.datetime :tweeted_at

      t.timestamps
    end
  end
end
