class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :project_id
      t.integer :event_id

      t.timestamps
    end
    change_table :images do |t|
      t.has_attached_file :file
    end
  end
end
