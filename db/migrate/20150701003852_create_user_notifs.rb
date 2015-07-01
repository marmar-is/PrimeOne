class CreateUserNotifs < ActiveRecord::Migration
  def change
    create_table :user_notifs do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :notif, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
