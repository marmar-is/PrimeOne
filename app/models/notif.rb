class Notif < ActiveRecord::Base
  # Associations
  has_many :users

  def seen_by?(u)
    return self.users.include?(u)
  end
end
