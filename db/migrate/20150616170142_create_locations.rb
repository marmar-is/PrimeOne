class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :number, default: 0
      t.string :street, default: ""
      t.string :city, default: ""
      t.string :state, default: ""
      t.string :zip, default: ""

      t.timestamps null: false
    end
    add_reference :locations, :policy, index: true, foreign_key: true
  end
end
