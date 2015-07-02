class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      # container fields
      t.string :number, default: ""
      t.string :status, default: "EMPTY"
      t.string :code, default: ""
      t.string :name, default: ""
      t.date :effective, default: "1995-11-08"

      # form lists
      t.string :forms, default: ""
      t.string :property_forms, default: ""
      t.string :gl_forms, default: ""
      t.string :crime_forms, default: ""
      t.string :auto_forms, default: ""

      t.timestamps null: false
    end

    add_index :policies, :number, unique: true
    add_reference :policies, :broker, index: true, foreign_key: true
  end
end
