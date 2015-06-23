class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :number, default: 0
      t.string :street, default: ""
      t.string :city, default: ""
      t.string :state, default: ""
      t.string :zip, default: ""

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
      t.string :indemnity, default: ""

      t.timestamps null: false
    end
    add_reference :locations, :policy, index: true, foreign_key: true
  end
end
