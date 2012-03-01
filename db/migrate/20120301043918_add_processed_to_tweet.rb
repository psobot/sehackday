class AddProcessedToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :processed, :boolean
  end
end
