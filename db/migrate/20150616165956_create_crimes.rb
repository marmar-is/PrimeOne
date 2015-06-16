class CreateCrimes < ActiveRecord::Migration
  def change
    create_table :crimes do |t|
      t.decimal :total, default: 0
      
      t.decimal :ded, default: 0
      t.decimal :limit_theft, default: 0
      t.decimal :limit_forgery, default: 0
      t.decimal :limit_money, default: 0
      t.decimal :limit_outside_robbery, default: 0
      t.decimal :limit_safe_burglary, default: 0
      t.decimal :limit_premises_burglary, default: 0

      t.timestamps null: false
    end
    add_reference :crimes, :policy, index: true, foreign_key: true
  end
end
