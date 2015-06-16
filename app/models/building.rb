class Building < ActiveRecord::Base
  # Associatons
  belongs_to :location

  default_scope { order('created_at ASC') }
end
