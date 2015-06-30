class Notif < ActiveRecord::Base
  # Associations
  #belongs_to :policy
  #has_many :users

  def seen_by?(u)
    #return self.users.include?(u)
  end

end
