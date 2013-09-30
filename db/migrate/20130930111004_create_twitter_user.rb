class CreateTwitterUser < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.string :screen_name
      t.string :name
      t.string :location
      t.string :description
      t.integer :twitter_id, limit: 8

      t.timestamps
    end
  end
end
