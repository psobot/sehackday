class AddDescriptionToProject < ActiveRecord::Migration
  def change
    add_column :projects, :description, :string, :after => :link
  end
end
