class CreateNotifs < ActiveRecord::Migration
  def change
    create_table :notifs do |t|
      t.belongs_to :policy
      t.belongs_to :user
      #t.string :number
      #t.string :message
      #t.string :status

      t.timestamps null: false
    end
  end
end
