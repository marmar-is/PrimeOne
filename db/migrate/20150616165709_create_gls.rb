class CreateGls < ActiveRecord::Migration
  def change
    create_table :gls do |t|
      t.decimal :total, default: 0

      t.decimal :limit_genagg, default: 0
      t.decimal :limit_products, default: 0
      t.decimal :limit_occurence, default: 0
      t.decimal :limit_injury, default: 0
      t.decimal :limit_fire, default: 0
      t.decimal :limit_medical, default: 0

      t.string :water_gas_tank, default: ""

      t.timestamps null: false
    end
    add_reference :gls, :policy, index: true, foreign_key: true
  end
end
