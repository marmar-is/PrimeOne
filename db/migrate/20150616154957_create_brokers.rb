class CreateBrokers < ActiveRecord::Migration
  def change
    create_table :brokers do |t|
      t.string :name, default: ""
      t.string :code, default: ""

      t.string :contact_name, default: ""
      t.string :email, default: ""
      t.string :phone, default: ""

      t.string :street, default: ""
      t.string :city, default: ""
      t.string :state, default: ""
      t.string :zip, default: ""

      t.timestamps null: false
    end
    add_index :brokers, :code, unique: true
  end
end
