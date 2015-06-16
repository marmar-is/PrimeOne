class AddFieldsToPolicy < ActiveRecord::Migration
  def change
    add_column :policies, :expiry, :date, default: "1995-11-08"

    add_column :policies, :org, :string, default: ""
    add_column :policies, :dba, :string, default: ""
    add_column :policies, :biztype, :string, default: ""

    # Address
    add_column :policies, :street, :string, default: ""
    add_column :policies, :city, :string, default: ""
    add_column :policies, :state, :string, default: ""
    add_column :policies, :zip, :string, default: ""

    add_column :policies, :total_premium, :decimal, default: 0
  end
end
