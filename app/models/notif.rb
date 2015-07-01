class Notif < ActiveRecord::Base
  # Associations
  has_many :user_notifs
  has_many :users, through: :user_notifs

end
