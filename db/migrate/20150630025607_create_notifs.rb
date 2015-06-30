class CreateNotifs < ActiveRecord::Migration
  def change
    create_table :notifs do |t|
      t.string :number
      t.string :message
      t.string :status

      t.timestamps null: false
    end
  end
end
