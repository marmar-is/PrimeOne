class UserNotif < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :notif
end
