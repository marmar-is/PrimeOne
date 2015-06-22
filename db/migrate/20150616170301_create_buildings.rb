class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.integer :number, default: 0
      t.string :class_type, default: ""
      t.string :code, default: ""
      t.decimal :basis, default: 0
      t.string :basis_type, default: ""

      t.timestamps null: false
    end
    add_reference :buildings, :location, index: true, foreign_key: true
  end
end
