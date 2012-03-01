class CreateTables < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :full_name
      t.string :first_name
      t.string :last_name
      t.string :username
      
      t.boolean :is_admin

      t.integer :tweet_id

      t.timestamps
    end
    create_table :projects do |t|
      t.string :name
      t.string :link

      t.integer :tweet_id

      t.timestamps
    end
    create_table :contributions do |t|
      t.integer :participant_id
      t.integer :project_id
      t.integer :event_id

      t.integer :tweet_id

      t.timestamps
    end
    create_table :attendances do |t|
      t.integer :participant_id
      t.integer :event_id

      t.integer :tweet_id
  
      t.timestamps
    end
    create_table :events do |t|
      t.datetime :start
      t.datetime :finish
      t.integer :location_id
      t.integer :tweet_id
      
      t.timestamps
    end
    create_table :locations do |t|
      t.string :name
      t.string :address

      t.float :lat
      t.float :lng

      t.integer :tweet_id

      t.timestamps
    end
    create_table :tweets do |t|
      t.string :username
      t.float :lat
      t.float :lng
      t.string :raw
      
      t.timestamps
    end
  end
end
