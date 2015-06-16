class CreateAutos < ActiveRecord::Migration
  def change
    create_table :autos do |t|
      t.decimal :total, default: 0

      t.timestamps null: false
    end
    add_reference :autos, :policy, index: true, foreign_key: true
  end
end
