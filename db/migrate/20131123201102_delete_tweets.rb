class DeleteTweets < ActiveRecord::Migration
  def change
    drop_table :tweets
    remove_column :attendances, :tweet_id
    remove_column :contributions, :tweet_id
    remove_column :events, :tweet_id
    remove_column :locations, :tweet_id
    remove_column :participants, :tweet_id
    remove_column :projects, :tweet_id
  end
end
