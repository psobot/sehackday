class FixTwitterTable < ActiveRecord::Migration
  def change
    add_column :tweets, :tweet_id, :integer, :after => :id
    remove_column :tweets, :processed
    add_column :tweets, :processed, :boolean, :after => :raw, :default => false
  end
end
