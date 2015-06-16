class Broker < ActiveRecord::Base
  # Associations
  has_many :policies
end
