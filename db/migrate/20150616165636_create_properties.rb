class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.decimal :total, default: 0

      t.timestamps null: false
    end
    add_reference :properties, :policy, index: true, foreign_key: true
  end
end
