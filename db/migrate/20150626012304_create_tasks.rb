class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :status
      t.boolean :seen

      t.timestamps null: false
    end

    add_reference :tasks, :policy, index: true, foreign_key: true
  end
end
