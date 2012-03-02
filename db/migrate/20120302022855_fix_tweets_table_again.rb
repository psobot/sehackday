class FixTweetsTableAgain < ActiveRecord::Migration
  def change
    change_column :tweets, :tweet_id, :string
    change_column :tweets, :raw, :text
  end
end
