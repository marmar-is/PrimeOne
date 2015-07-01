class Notif < ActiveRecord::Base
  # Associations
  belongs_to :policy
  belongs_to :user

end
