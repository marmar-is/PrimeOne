class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.integer :number, default: 0
      t.string :class_type, default: ""
      t.string :code, default: ""
      t.decimal :basis, default: 0
      t.string :basis_type, default: ""
      t.decimal :total, default: 0
      t.string :loss_coverage, default: ""
      t.string :enhancement, default: ""
      t.string :mechanical, default: ""
      t.string :theft, default: ""
      t.string :spoilage, default: ""
      t.decimal :coins, default: 0
      t.string :valuation, default: ""
      t.decimal :ded, default: 0
      t.decimal :limt_bldg, default: 0
      t.decimal :limit_bpp, default: 0
      t.decimal :limit_earnings, default: 0
      t.decimal :limit_sign, default: 0
      t.decimal :limit_pumps, default: 0
      t.decimal :limit_canopies, default: 0
      t.decimal :indemnity, default: ""

      t.timestamps null: false
    end
    add_reference :buildings, :location, index: true, foreign_key: true
  end
end
