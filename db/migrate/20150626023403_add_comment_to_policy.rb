class AddCommentToPolicy < ActiveRecord::Migration
  def change
    add_column :policies, :comment, :text, default:''
  end
end
