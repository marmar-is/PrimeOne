class CreateNotifs < ActiveRecord::Migration
  def change
    create_table :notifs do |t|
      t.belongs_to :policy
      t.belongs_to :user

      t.string :message, default: false
      t.string :message_type, default: ''
      t.boolean :seen, default: false
      #t.string :number
      #t.string :status

      t.timestamps null: false
    end
  end
end
