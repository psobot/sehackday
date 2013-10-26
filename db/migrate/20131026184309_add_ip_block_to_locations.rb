class AddIpBlockToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :ip_block, :string
  end
end
