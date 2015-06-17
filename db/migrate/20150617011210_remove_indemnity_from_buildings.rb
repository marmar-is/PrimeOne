class RemoveIndemnityFromBuildings < ActiveRecord::Migration
  def up
    remove_column :buildings, :indemnity
  end

  def down
    add_column :buildings, :indemnity, :string
  end
end
