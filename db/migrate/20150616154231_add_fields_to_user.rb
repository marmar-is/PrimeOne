class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :fname, :string, default: ""
    add_column :users, :lname, :string, default: ""
  end
end
