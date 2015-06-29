class Task < ActiveRecord::Base
  # Associations
  has_many :users
end
